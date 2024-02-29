module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.35.0"
  
  identifier           = "demodb"
  engine               = "mysql"
  engine_version       = "8.0.35"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class       = "db.t4g.large"
  
  
  allocated_storage     = 5
  max_allocated_storage = 100

  username = "admin"
  port     = "3306"
  password = "Qaz123456789*2024"
  option_group_name = "mysql-8-0"
  parameter_group_name = "mysql-8-0"
  
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.rds.id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  backup_retention_period         = 0
  #create_cloudwatch_log_group     = true
  enabled_cloudwatch_logs_exports = ["general"]
  
  
  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = "30"
  monitoring_role_name                  = "MyRDSMonitoringRole"
  
  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
  
  skip_final_snapshot = true
  deletion_protection = false # Database Deletion Protection
  
  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]

}