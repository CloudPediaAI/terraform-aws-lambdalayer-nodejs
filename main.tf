locals {
  nodejs_runtimes   = ["nodejs24.x", "nodejs22.x", "nodejs20.x"]
  lambda_layer_name = (var.layer_name == "null") ? "lib-nodejs-${var.library_name}" : var.layer_name
  lambda_runtime    = contains(local.nodejs_runtimes, var.nodejs_runtime) ? var.nodejs_runtime : local.nodejs_runtimes[0]
}

locals {
  project_folder = "${path.module}/lambdalayer/${var.library_name}"
  metadata_file  = "${local.project_folder}/package.json"
  package_file   = "${path.module}/layer-node-${var.library_name}.zip"
}

# ensure per-library project folder exists for any library_name
resource "null_resource" "create_project_folder" {
  triggers = {
    project_folder = local.project_folder
  }

  provisioner "local-exec" {
    command = "mkdir ${local.project_folder}"
  }
}

# create folders and a dummy file
resource "local_file" "package_json" {
  depends_on = [null_resource.create_project_folder]

  content  = <<EOF
{
  "name": "${local.lambda_layer_name}",
  "version": "1.0.0",
  "description": "Node.js library to create Lambda Layer",
  "main": "index.js",
  "scripts": {
    "test": "echo test"
  },
  "author": "CloudPediaAI",
  "license": "ISC"
} 
EOF
  filename = local.metadata_file
}

# waiting to get the folders and dummy file created
resource "time_sleep" "until_folder_creation" {
  depends_on      = [local_file.package_json]
  create_duration = "5s"
}

# installing Node.js library
resource "null_resource" "install_nodejs_library" {

  depends_on = [
    local_file.package_json,
    time_sleep.until_folder_creation
  ]

  # trigger on timestamp change will make sure local-exec runs always
  triggers = {
    always_run = "${timestamp()}"
  }

  # skip this block if the package already exists
  count = fileexists(local.package_file) ? 0 : 1

  # install Node.js library
  provisioner "local-exec" {
    command = "cd ${local.project_folder} && npm install ${var.library_name}"
  }
}

# waiting until library installation completes
resource "time_sleep" "until_install_completion" {
  depends_on = [
    local_file.package_json,
    time_sleep.until_folder_creation,
    null_resource.install_nodejs_library
  ]

  create_duration = "10s"
}

# create package to upload to Lambda Layer
data "archive_file" "create_package" {

  depends_on = [
    local_file.package_json,
    time_sleep.until_folder_creation,
    null_resource.install_nodejs_library,
    time_sleep.until_install_completion
  ]

  count = fileexists(local.package_file) ? 0 : 1

  type        = "zip"
  source_dir  = local.project_folder
  output_path = local.package_file
}

# creates lambda layer
resource "aws_lambda_layer_version" "nodejs_library" {
  depends_on = [
    local_file.package_json,
    time_sleep.until_folder_creation,
    null_resource.install_nodejs_library,
    time_sleep.until_install_completion,
    data.archive_file.create_package
  ]
  filename            = local.package_file
  layer_name          = local.lambda_layer_name
  compatible_runtimes = [var.nodejs_runtime]
}
