# Mostly from : https://github.com/terraform-aws-modules/terraform-aws-ecs/tree/v5.11.0/examples/ec2-autoscaling

provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  region = var.region
  name   = var.ecs_cluster_name

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  container_name = "metabase"
  container_port = var.app_container_port

  tags = var.tags

  db_port = 5432
  db_name = "metabase"

  env_vars_metabase = {
    "MB_DB_TYPE" : "postgres",
    "MB_DB_DBNAME" : local.db_name,
    "MB_DB_PORT" : "${local.db_port}"
    "MB_DB_HOST" : module.db_default.db_instance_address
  }
}

################################################################################
# Cluster
################################################################################

module "ecs_cluster" {

  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.0"


  cluster_name = local.name

  # Capacity provider - autoscaling groups
  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = merge(
    {
      # On-demand instances
      pool1 = {
        auto_scaling_group_arn         = module.autoscaling["pool1"].autoscaling_group_arn
        managed_termination_protection = "ENABLED"

        managed_scaling = {
          maximum_scaling_step_size = 5
          minimum_scaling_step_size = 1
          status                    = "ENABLED"
          target_capacity           = 60
        }

        default_capacity_provider_strategy = {
          weight = 60
          base   = 20
        }
      }
    },
    var.ecs_enable_spot == false ? {} : {
      pool2 = {
        auto_scaling_group_arn         = module.autoscaling["pool2"].autoscaling_group_arn
        managed_termination_protection = "ENABLED"

        managed_scaling = {
          maximum_scaling_step_size = 15
          minimum_scaling_step_size = 5
          status                    = "ENABLED"
          target_capacity           = 90
        }

        default_capacity_provider_strategy = {
          weight = 40
        }
      }
    }
  )

  tags = local.tags
}

################################################################################
# Service
################################################################################

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.6"

  # Service
  name        = local.name
  cluster_arn = module.ecs_cluster.cluster_arn

  # Task Definition
  requires_compatibilities = ["EC2"]
  capacity_provider_strategy = {
    # On-demand instances
    pool1 = {
      capacity_provider = module.ecs_cluster.autoscaling_capacity_providers["pool1"].name
      weight            = 1
      base              = 1
    }
  }

  volume = {
    my-vol = {}
  }

  cpu    = var.task_cpu
  memory = var.task_memory

  # Container definition(s)
  container_definitions = {
    (local.container_name) = {
      image = var.app_image

      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]

      mount_points = [
        {
          sourceVolume  = "my-vol",
          containerPath = "/var/www/my-vol"
        }
      ]
      environment = [for k, v in merge(local.env_vars_metabase, var.app_env_vars) : { "name" : k, "value" : v }]

      "secrets" : [{
        "name" : "MB_DB_USER",
        "valueFrom" : "${module.db_default.db_instance_master_user_secret_arn}:username::"
        }, {
        "name" : "MB_DB_PASS",
        "valueFrom" : "${module.db_default.db_instance_master_user_secret_arn}:password::"
        }
      ]



      essential = true,
      healthCheck = {
        command  = ["CMD-SHELL", "curl --fail -I http://localhost:3000/api/health || exit 1"],
        interval = 30
        timeout  = 5
        retries  = 3
      }

      readonly_root_filesystem = false

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${local.name}/${local.container_name}"
      cloudwatch_log_group_retention_in_days = 7

      log_configuration = {
        logDriver = "awslogs"
      }
    }
  }

  task_exec_secret_arns = [module.db_default.db_instance_master_user_secret_arn]


  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["metabase_ecs"].arn
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_http_ingress = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = local.name

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "metabase_ecs"
      }
    }
  }

  target_groups = {
    metabase_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = local.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # Theres nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

  tags = local.tags
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"

  for_each = merge({
    # On-demand instances
    pool1 = {
      instance_type              = var.instance_type_ondemand
      use_mixed_instances_policy = false
      mixed_instances_policy     = {}
      user_data                  = <<-EOT
            #!/bin/bash

            cat <<'EOF' >> /etc/ecs/ecs.config
            ECS_CLUSTER=${local.name}
            ECS_LOGLEVEL=debug
            ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.tags)}
            ECS_ENABLE_TASK_IAM_ROLE=true
            EOF
        EOT
    }
    },
    # Spot instances
    var.ecs_enable_spot == false ? {} : {
      pool2 = {
        instance_type              = var.instance_type_spot
        use_mixed_instances_policy = true
        mixed_instances_policy = {
          instances_distribution = {
            on_demand_base_capacity                  = 0
            on_demand_percentage_above_base_capacity = 0
            spot_allocation_strategy                 = "price-capacity-optimized"
          }

          override = [
            {
              instance_type     = "m4.large"
              weighted_capacity = "2"
            },
            {
              instance_type     = "t3.large"
              weighted_capacity = "1"
            },
          ]
        }
        user_data = <<-EOT
            #!/bin/bash

            cat <<'EOF' >> /etc/ecs/ecs.config
            ECS_CLUSTER=${local.name}
            ECS_LOGLEVEL=debug
            ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.tags)}
            ECS_ENABLE_TASK_IAM_ROLE=true
            ECS_ENABLE_SPOT_INSTANCE_DRAINING=true
            EOF
        EOT
      }
    }
  )

  name = "${local.name}-${each.key}"

  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = each.value.instance_type

  security_groups                 = [module.autoscaling_sg.security_group_id]
  user_data                       = base64encode(each.value.user_data)
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true
  iam_role_name               = "${local.name}-node"
  iam_role_description        = "ECS Node (Instances) role for ${local.name}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type   = "EC2"
  min_size            = var.ecs_min_size
  max_size            = var.ecs_max_size
  desired_capacity    = var.ecs_desired_capacity

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = true

  # Spot instances
  use_mixed_instances_policy = each.value.use_mixed_instances_policy
  mixed_instances_policy     = each.value.mixed_instances_policy

  tags = local.tags
}

module "autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Autoscaling group security group"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb.security_group_id
    },
    {
      rule                     = "http-443-tcp"
      source_security_group_id = module.alb.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 51)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}


module "db_default" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.5.4"

  identifier                     = "${local.name}-default"
  instance_use_identifier_prefix = true

  create_db_option_group    = false
  create_db_parameter_group = false

  engine               = "postgres"
  engine_version       = "14.10"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t4g.micro"

  allocated_storage = 10

  db_name  = local.db_name
  username = "complete_postgresql"
  port     = local.db_port

  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.rds_security_group.security_group_id]

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = local.tags
}


module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Autoscaling group security group"
  vpc_id      = module.vpc.vpc_id


  # ingress_with_cidr_blocks = [for i in module.vpc.private_subnets_cidr_blocks :
  #   {
  #     rule        = "postgresql-tcp"
  #     cidr_blocks = i
  #   }
  # ]
  # # computed_ingress_with_source_security_group_id = [
  # #   {
  # #     rule                     = "postgresql-tcp"
  # #     source_security_group_id = module.autoscaling_sg.security_group_id
  # #   },
  # # ]
  # # number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.tags
}

## Avoid cyclic dependency
resource "aws_security_group_rule" "ecs_svc_to_rds" {
  type      = "ingress"
  from_port = local.db_port
  to_port   = local.db_port
  protocol  = "tcp"

  source_security_group_id = module.ecs_service.security_group_id
  security_group_id        = module.rds_security_group.security_group_id
}
