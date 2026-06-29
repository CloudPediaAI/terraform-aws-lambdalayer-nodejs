# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.3] - 2026-06-28

### Added
- Node.js 24 (nodejs24.x) runtime support for Lambda Layer compatibility with the latest Node.js LTS version

### Changed
- Updated package filename variable to use more descriptive naming (`layer-node-${var.library_name}.zip`)
- Optimized folder creation wait time for improved provisioning performance (`time_sleep.until_folder_creation`: `10s` -> `5s`)

## [1.3.2] - 2024-XX-XX

### Changed
- Refactored layer build paths to use an absolute, module-scoped project folder (`${path.module}/lambdalayer/${var.library_name}`) to improve packaging consistency across environments
- Updated package artifact location to be generated directly under the library project folder (`nodejs-${var.library_name}.zip`)
- Updated archive source path to use the resolved project folder so the ZIP is built from the correct directory
- Increased provisioning wait time for folder creation to reduce intermittent startup failures (`time_sleep.until_folder_creation`: `1s` -> `10s`)
- Increased provisioning wait time after dependency installation to improve archive timing reliability (`time_sleep.until_install_completion`: `10s` -> `20s`)

## [1.1.0] - 2024-06-12

### Removed
- Node.js 16 (nodejs16.x) from the allowed runtime list as AWS ended support for Node.js 16 in Lambda on June 12, 2024

### Changed
- Input variable **nodejs_runtime** will not allow **nodejs16.x** anymore. You can provide either **nodejs20.x** or **nodejs18.x** as runtime
