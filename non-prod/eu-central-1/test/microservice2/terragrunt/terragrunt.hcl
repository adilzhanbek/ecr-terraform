terraform {
   source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecr.git//?ref=master"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  name_vars = read_terragrunt_config(find_in_parent_folders("name.hcl"))

  org          = local.global_vars.locals.org
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.account_id
  aws_region   = local.region_vars.locals.aws_region
  env          = local.environment_vars.locals.env
  name         = local.name_vars.locals.name

  name_of_repository = "${local.org}-${local.env}-${local.aws_region}-${local.name}"
}

inputs = {

create = true

repository_name = local.name_of_repository

create_lifecycle_policy = true

 repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
 
}
