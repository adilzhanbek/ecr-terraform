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

  path_to_folder = get_terragrunt_dir()

  name = regex("/([^/]+)$", local.path_to_folder)[0] #taking last value of the path_to_dir (exmp: microservice1)

  org          = local.global_vars.locals.org
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.account_id
  aws_region   = local.region_vars.locals.aws_region
  env          = local.environment_vars.locals.env
}

inputs = {

create = true

repository_name = local.name

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
