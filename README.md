# Lambda Layer for Node.js Libraries
When your Lambda need to import libraries, packaing all libraries along with your business logic is not recommended.  Instead you can upload libraries as Lambda Layers, so that multiple Lambda functions can access libray from a common location (layer).  This module will create an AWS Lambda Layer with ANY nodejs library you like.   

## Links
- [Documentation](https://cloudpedia.ai/terraform-module/aws-lambdalayer-nodejs/)
- [Terraform module](https://registry.terraform.io/modules/cloudpediaai/lambdalayer-nodejs/aws/latest)
- [GitHub Repo](https://github.com/CloudPediaAI/terraform-aws-lambdalayer-nodejs)

## Related Terraform Modules from CloudPedia.AI

### Scheduled Job for AWS
- [Documentation](https://cloudpedia.ai/terraform-module/aws-scheduled-job/)
- [Terraform module](https://registry.terraform.io/modules/cloudpediaai/scheduled-job/aws/latest)
- [GitHub Repo](https://github.com/CloudPediaAI/terraform-aws-scheduled-job)

### Lambda Layer for Python Libraries
- [Documentation](https://cloudpedia.ai/terraform-module/aws-lambdalayer-python/)
- [Terraform module](https://registry.terraform.io/modules/cloudpediaai/lambdalayer-python/aws/latest)
- [GitHub Repo](https://github.com/CloudPediaAI/terraform-aws-lambdalayer-python)


# Release Notes

## v1.1.0

### Changes/Updates

Removed **Node.js 16 (nodejs16.x)** from the allowed runtime list as AWS is ending support for Node.js 16 in Lambda on June 12, 2024.  [Read our blog](https://cloudpedia.ai/blog/nodejs-16-end-of-support-upgrade-now/) for more details. 

### Input Variable Changes
- Input variable **nodejs_runtime** will not allow **nodejs16.x** anymore.  You can provide either **nodejs20.x** or **nodejs18.x** as runtime.

### Output Variable Changes
None