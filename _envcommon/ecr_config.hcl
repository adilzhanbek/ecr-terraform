# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for webserver-cluster. The common variables for each environment to
# deploy webserver-cluster are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
 # ######environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  ########env = local.environment_vars.locals.environment

  # Expose the base source URL so different versions of the module can be deployed in different environments.
  
  #git@github.com:terraform-aws-modules/terraform-aws-ecr.git//wrappers
  
 # base_source_url = "git::git@github.com:terraform-aws-modules/terraform-aws-ecr.git//wrappers?ref=master"
  
  
 # base_source_url = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//asg-elb-service"

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
#inputs = {
  # name          = "webserver-example-${local.env}"
  # instance_type = "t3.micro"

  # # min_size = 1
  # # max_size = 2

  # server_port = 8080
  # elb_port    = 80
  name_private   = "abr-p33rivate-${replace(basename(path.cwd), "_", "-")}"
  name_public = "abr-pu33blic-${replace(basename(path.cwd), "_", "-")}"
  tag_name = "test-tag"
  tags = {
    Name       = local.tag_name
    Example    = local.tag_name
    Repository = "https://github.com/adilzhanbek/ecr-test"
  }
  }




inputs = {
repository_name = local.name_private

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





#}
