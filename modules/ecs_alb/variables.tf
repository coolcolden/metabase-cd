

variable "region" {
  description = "The region to create all stack"
  type        = string
  default     = "eu-west-1"
}

variable "ecs_cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
  type        = string
}

variable "tags" {
  description = "Tags to use on resources"
  type        = map(list(string))
  default = {
    Name       = "metabase"
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
  }
}
