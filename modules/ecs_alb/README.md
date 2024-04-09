AWS and ECS Provisioning
========================

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.66.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.66.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 9.0 |
| <a name="module_autoscaling"></a> [autoscaling](#module\_autoscaling) | terraform-aws-modules/autoscaling/aws | ~> 6.5 |
| <a name="module_autoscaling_sg"></a> [autoscaling\_sg](#module\_autoscaling\_sg) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_db_default"></a> [db\_default](#module\_db\_default) | terraform-aws-modules/rds/aws | ~> 6.5.4 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | terraform-aws-modules/ecs/aws | 5.11.0 |
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | ~> 5.6 |
| <a name="module_rds_security_group"></a> [rds\_security\_group](#module\_rds\_security\_group) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.ecs_svc_to_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_ssm_parameter.ecs_optimized_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_container_name"></a> [app\_container\_name](#input\_app\_container\_name) | The name for the container | `string` | `"metabase"` | no |
| <a name="input_app_container_port"></a> [app\_container\_port](#input\_app\_container\_port) | The port on the container | `number` | `3000` | no |
| <a name="input_app_env_vars"></a> [app\_env\_vars](#input\_app\_env\_vars) | A set of environment variables to be exposed to the container's app | `map(string)` | `{}` | no |
| <a name="input_app_image"></a> [app\_image](#input\_app\_image) | The image for the app | `string` | `"metabase/metabase:latest"` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Database to create inside the postgress | `string` | `"metabase"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The cluster name | `string` | n/a | yes |
| <a name="input_ecs_desired_capacity"></a> [ecs\_desired\_capacity](#input\_ecs\_desired\_capacity) | Desired number of instances on ECS Autoscaling group | `number` | `2` | no |
| <a name="input_ecs_enable_spot"></a> [ecs\_enable\_spot](#input\_ecs\_enable\_spot) | Enable usage of spot instances on a second ASG | `bool` | `false` | no |
| <a name="input_ecs_max_size"></a> [ecs\_max\_size](#input\_ecs\_max\_size) | Minimum number of instances on ECS Autoscaling group | `number` | `3` | no |
| <a name="input_ecs_min_size"></a> [ecs\_min\_size](#input\_ecs\_min\_size) | Minimum number of instances on ECS Autoscaling group | `number` | `1` | no |
| <a name="input_instance_type_ondemand"></a> [instance\_type\_ondemand](#input\_instance\_type\_ondemand) | The instance type for the onDemand nodes | `string` | `"t3.micro"` | no |
| <a name="input_instance_type_spot"></a> [instance\_type\_spot](#input\_instance\_type\_spot) | The instance type for the Spot nodes | `string` | `"t3.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create all stack | `string` | `"us-west-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to use on resources | `map(string)` | <pre>{<br>  "Name": "metabase",<br>  "Repository": "https://github.com/terraform-aws-modules/terraform-aws-ecs"<br>}</pre> | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | CPU to request to ECS in milliCPU, valid values, should correlate to `task_memory`: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | `number` | `1500` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Memory to allocate, in MB, valid values here, should correlate to `task_cpu`: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html | `number` | `900` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN that identifies the cluster |
| <a name="output_cluster_autoscaling_capacity_providers"></a> [cluster\_autoscaling\_capacity\_providers](#output\_cluster\_autoscaling\_capacity\_providers) | Map of capacity providers created and their attributes |
| <a name="output_cluster_capacity_providers"></a> [cluster\_capacity\_providers](#output\_cluster\_capacity\_providers) | Map of cluster capacity providers attributes |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID that identifies the cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name that identifies the cluster |
| <a name="output_db_default_instance_address"></a> [db\_default\_instance\_address](#output\_db\_default\_instance\_address) | The address of the RDS instance |
| <a name="output_db_default_instance_arn"></a> [db\_default\_instance\_arn](#output\_db\_default\_instance\_arn) | The ARN of the RDS instance |
| <a name="output_db_default_instance_availability_zone"></a> [db\_default\_instance\_availability\_zone](#output\_db\_default\_instance\_availability\_zone) | The availability zone of the RDS instance |
| <a name="output_db_default_instance_cloudwatch_log_groups"></a> [db\_default\_instance\_cloudwatch\_log\_groups](#output\_db\_default\_instance\_cloudwatch\_log\_groups) | Map of CloudWatch log groups created and their attributes |
| <a name="output_db_default_instance_endpoint"></a> [db\_default\_instance\_endpoint](#output\_db\_default\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_default_instance_engine"></a> [db\_default\_instance\_engine](#output\_db\_default\_instance\_engine) | The database engine |
| <a name="output_db_default_instance_engine_version"></a> [db\_default\_instance\_engine\_version](#output\_db\_default\_instance\_engine\_version) | The running version of the database |
| <a name="output_db_default_instance_hosted_zone_id"></a> [db\_default\_instance\_hosted\_zone\_id](#output\_db\_default\_instance\_hosted\_zone\_id) | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| <a name="output_db_default_instance_identifier"></a> [db\_default\_instance\_identifier](#output\_db\_default\_instance\_identifier) | The RDS instance identifier |
| <a name="output_db_default_instance_name"></a> [db\_default\_instance\_name](#output\_db\_default\_instance\_name) | The database name |
| <a name="output_db_default_instance_port"></a> [db\_default\_instance\_port](#output\_db\_default\_instance\_port) | The database port |
| <a name="output_db_default_instance_resource_id"></a> [db\_default\_instance\_resource\_id](#output\_db\_default\_instance\_resource\_id) | The RDS Resource ID of this instance |
| <a name="output_db_default_instance_status"></a> [db\_default\_instance\_status](#output\_db\_default\_instance\_status) | The RDS instance status |
| <a name="output_db_default_instance_username"></a> [db\_default\_instance\_username](#output\_db\_default\_instance\_username) | The master username for the database |
| <a name="output_db_default_master_user_secret_arn"></a> [db\_default\_master\_user\_secret\_arn](#output\_db\_default\_master\_user\_secret\_arn) | The ARN of the master user secret (Only available when manage\_master\_user\_password is set to true) |
| <a name="output_db_default_parameter_group_arn"></a> [db\_default\_parameter\_group\_arn](#output\_db\_default\_parameter\_group\_arn) | The ARN of the db parameter group |
| <a name="output_db_default_parameter_group_id"></a> [db\_default\_parameter\_group\_id](#output\_db\_default\_parameter\_group\_id) | The db parameter group id |
| <a name="output_db_default_secretsmanager_secret_rotation_enabled"></a> [db\_default\_secretsmanager\_secret\_rotation\_enabled](#output\_db\_default\_secretsmanager\_secret\_rotation\_enabled) | Specifies whether automatic rotation is enabled for the secret |
| <a name="output_db_default_subnet_group_arn"></a> [db\_default\_subnet\_group\_arn](#output\_db\_default\_subnet\_group\_arn) | The ARN of the db subnet group |
| <a name="output_db_default_subnet_group_id"></a> [db\_default\_subnet\_group\_id](#output\_db\_default\_subnet\_group\_id) | The db subnet group name |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The DNS name of the load balancer |
| <a name="output_service_autoscaling_policies"></a> [service\_autoscaling\_policies](#output\_service\_autoscaling\_policies) | Map of autoscaling policies and their attributes |
| <a name="output_service_autoscaling_scheduled_actions"></a> [service\_autoscaling\_scheduled\_actions](#output\_service\_autoscaling\_scheduled\_actions) | Map of autoscaling scheduled actions and their attributes |
| <a name="output_service_container_definitions"></a> [service\_container\_definitions](#output\_service\_container\_definitions) | Container definitions |
| <a name="output_service_iam_role_arn"></a> [service\_iam\_role\_arn](#output\_service\_iam\_role\_arn) | Service IAM role ARN |
| <a name="output_service_iam_role_name"></a> [service\_iam\_role\_name](#output\_service\_iam\_role\_name) | Service IAM role name |
| <a name="output_service_iam_role_unique_id"></a> [service\_iam\_role\_unique\_id](#output\_service\_iam\_role\_unique\_id) | Stable and unique string identifying the service IAM role |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ARN that identifies the service |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the service |
| <a name="output_service_task_definition_arn"></a> [service\_task\_definition\_arn](#output\_service\_task\_definition\_arn) | Full ARN of the Task Definition (including both `family` and `revision`) |
| <a name="output_service_task_definition_revision"></a> [service\_task\_definition\_revision](#output\_service\_task\_definition\_revision) | Revision of the task in a particular family |
| <a name="output_service_task_exec_iam_role_arn"></a> [service\_task\_exec\_iam\_role\_arn](#output\_service\_task\_exec\_iam\_role\_arn) | Task execution IAM role ARN |
| <a name="output_service_task_exec_iam_role_name"></a> [service\_task\_exec\_iam\_role\_name](#output\_service\_task\_exec\_iam\_role\_name) | Task execution IAM role name |
| <a name="output_service_task_exec_iam_role_unique_id"></a> [service\_task\_exec\_iam\_role\_unique\_id](#output\_service\_task\_exec\_iam\_role\_unique\_id) | Stable and unique string identifying the task execution IAM role |
| <a name="output_service_task_set_arn"></a> [service\_task\_set\_arn](#output\_service\_task\_set\_arn) | The Amazon Resource Name (ARN) that identifies the task set |
| <a name="output_service_task_set_id"></a> [service\_task\_set\_id](#output\_service\_task\_set\_id) | The ID of the task set |
| <a name="output_service_task_set_stability_status"></a> [service\_task\_set\_stability\_status](#output\_service\_task\_set\_stability\_status) | The stability status. This indicates whether the task set has reached a steady state |
| <a name="output_service_task_set_status"></a> [service\_task\_set\_status](#output\_service\_task\_set\_status) | The status of the task set |
| <a name="output_service_tasks_iam_role_arn"></a> [service\_tasks\_iam\_role\_arn](#output\_service\_tasks\_iam\_role\_arn) | Tasks IAM role ARN |
| <a name="output_service_tasks_iam_role_name"></a> [service\_tasks\_iam\_role\_name](#output\_service\_tasks\_iam\_role\_name) | Tasks IAM role name |
| <a name="output_service_tasks_iam_role_unique_id"></a> [service\_tasks\_iam\_role\_unique\_id](#output\_service\_tasks\_iam\_role\_unique\_id) | Stable and unique string identifying the tasks IAM role |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
