

variable "region" {
  description = "The region to create all stack"
  type        = string
  default     = "us-west-1"
}

variable "ecs_cluster_name" {
  description = "The cluster name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags to use on resources"
  type        = map(string)
  default = {
    Name       = "metabase"
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
  }
}

variable "app_image" {
  description = "The image for the app"
  type        = string
  default     = "metabase/metabase:latest"
}

variable "app_container_name" {
  description = "The name for the container"
  type        = string
  default     = "metabase"
}
variable "app_container_port" {
  description = "The port on the container"
  type        = number
  default     = 3000
}

variable "instance_type_ondemand" {
  description = "The instance type for the onDemand nodes"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_spot" {
  description = "The instance type for the Spot nodes"
  type        = string
  default     = "t3.micro"
}

variable "ecs_min_size" {
  description = "Minimum number of instances on ECS Autoscaling group"
  type        = number
  default     = 1
}
variable "ecs_desired_capacity" {
  description = "Desired number of instances on ECS Autoscaling group"
  type        = number
  default     = 2
}

variable "ecs_enable_spot" {
  description = "Enable usage of spot instances on a second ASG"
  type        = bool
  default     = false
}

variable "db_username" {
  description = "Database to create inside the postgress"
  default     = "metabase"
  type        = string
}
