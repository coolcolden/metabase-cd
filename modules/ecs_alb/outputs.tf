################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = module.ecs_cluster.cluster_arn
}

output "cluster_id" {
  description = "ID that identifies the cluster"
  value       = module.ecs_cluster.cluster_id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.ecs_cluster.cluster_name
}

output "cluster_capacity_providers" {
  description = "Map of cluster capacity providers attributes"
  value       = module.ecs_cluster.cluster_capacity_providers
}

output "cluster_autoscaling_capacity_providers" {
  description = "Map of capacity providers created and their attributes"
  value       = module.ecs_cluster.autoscaling_capacity_providers
}

################################################################################
# Service
################################################################################

output "service_id" {
  description = "ARN that identifies the service"
  value       = module.ecs_service.id
}

output "service_name" {
  description = "Name of the service"
  value       = module.ecs_service.name
}

output "service_iam_role_name" {
  description = "Service IAM role name"
  value       = module.ecs_service.iam_role_name
}

output "service_iam_role_arn" {
  description = "Service IAM role ARN"
  value       = module.ecs_service.iam_role_arn
}

output "service_iam_role_unique_id" {
  description = "Stable and unique string identifying the service IAM role"
  value       = module.ecs_service.iam_role_unique_id
}

output "service_container_definitions" {
  description = "Container definitions"
  value       = module.ecs_service.container_definitions
}

output "service_task_definition_arn" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)"
  value       = module.ecs_service.task_definition_arn
}

output "service_task_definition_revision" {
  description = "Revision of the task in a particular family"
  value       = module.ecs_service.task_definition_revision
}

output "service_task_exec_iam_role_name" {
  description = "Task execution IAM role name"
  value       = module.ecs_service.task_exec_iam_role_name
}

output "service_task_exec_iam_role_arn" {
  description = "Task execution IAM role ARN"
  value       = module.ecs_service.task_exec_iam_role_arn
}

output "service_task_exec_iam_role_unique_id" {
  description = "Stable and unique string identifying the task execution IAM role"
  value       = module.ecs_service.task_exec_iam_role_unique_id
}

output "service_tasks_iam_role_name" {
  description = "Tasks IAM role name"
  value       = module.ecs_service.tasks_iam_role_name
}

output "service_tasks_iam_role_arn" {
  description = "Tasks IAM role ARN"
  value       = module.ecs_service.tasks_iam_role_arn
}

output "service_tasks_iam_role_unique_id" {
  description = "Stable and unique string identifying the tasks IAM role"
  value       = module.ecs_service.tasks_iam_role_unique_id
}

output "service_task_set_id" {
  description = "The ID of the task set"
  value       = module.ecs_service.task_set_id
}

output "service_task_set_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the task set"
  value       = module.ecs_service.task_set_arn
}

output "service_task_set_stability_status" {
  description = "The stability status. This indicates whether the task set has reached a steady state"
  value       = module.ecs_service.task_set_stability_status
}

output "service_task_set_status" {
  description = "The status of the task set"
  value       = module.ecs_service.task_set_status
}

output "service_autoscaling_policies" {
  description = "Map of autoscaling policies and their attributes"
  value       = module.ecs_service.autoscaling_policies
}

output "service_autoscaling_scheduled_actions" {
  description = "Map of autoscaling scheduled actions and their attributes"
  value       = module.ecs_service.autoscaling_scheduled_actions
}

## RDS OUTPUT

output "db_default_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_default.db_instance_address
}

output "db_default_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_default.db_instance_arn
}

output "db_default_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_default.db_instance_availability_zone
}

output "db_default_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_default.db_instance_endpoint
}

output "db_default_instance_engine" {
  description = "The database engine"
  value       = module.db_default.db_instance_engine
}

output "db_default_instance_engine_version" {
  description = "The running version of the database"
  value       = module.db_default.db_instance_engine_version_actual
}

output "db_default_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_default.db_instance_hosted_zone_id
}

output "db_default_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.db_default.db_instance_identifier
}

output "db_default_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_default.db_instance_resource_id
}

output "db_default_instance_status" {
  description = "The RDS instance status"
  value       = module.db_default.db_instance_status
}

output "db_default_instance_name" {
  description = "The database name"
  value       = module.db_default.db_instance_name
}

output "db_default_instance_username" {
  description = "The master username for the database"
  value       = module.db_default.db_instance_username
  sensitive   = true
}

output "db_default_instance_port" {
  description = "The database port"
  value       = module.db_default.db_instance_port
}

output "db_default_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.db_default.db_subnet_group_id
}

output "db_default_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.db_default.db_subnet_group_arn
}

output "db_default_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.db_default.db_parameter_group_id
}

output "db_default_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_default.db_parameter_group_arn
}

output "db_default_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db_default.db_instance_cloudwatch_log_groups
}

output "db_default_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.db_default.db_instance_master_user_secret_arn
}

output "db_default_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = module.db_default.db_instance_secretsmanager_secret_rotation_enabled
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.dns_name
}
