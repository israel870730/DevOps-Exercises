resource "aws_ssm_maintenance_window_task" "maintenance_window_task-App1" {
  name            = "maintenance_window_task-App1"
  description     = "Task to start the group of EC2 instances App1"
  max_concurrency = 2
  max_errors      = 1
  priority        = 1
  task_arn        = "AWS-StartEC2Instance"
  #task_arn        = "AWS-StopEC2Instance"
  task_type       = "AUTOMATION"
  window_id       = aws_ssm_maintenance_window.maintenance_window-App1.id
  service_role_arn = aws_iam_role.Start-Stop-EC2-SSM.arn
  targets {
    #Aqui le paso el target 
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.maintenance_window_target-App1.id]
  }

  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"
      #Aqui se le pasa los parametros que lleva la funcion
      parameter {
        name   = "InstanceId"
        values = ["{{RESOURCE_ID}}"]
      }
    }
  }
}

resource "aws_ssm_maintenance_window_task" "maintenance_window_task-sns" {
  name            = "maintenance_window_task-sns"
  description     = "Send a SNS msg"
  priority        = 20
  task_arn        = "AWS-PublishSNSNotification"
  task_type       = "AUTOMATION"
  window_id       = aws_ssm_maintenance_window.maintenance_window-App1.id
  service_role_arn = aws_iam_role.Start-Stop-EC2-SSM.arn

  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"
      #Aqui se le pasa los parametros que lleva la funcion
      parameter {
        name   = "TopicArn"
        values = [aws_sns_topic.topic-sns-ssm.arn]
        #values = ["arn:aws:sns:us-east-1:114712064551:test-ssm"]
      }
      parameter {
        name   = "Message"
        values = ["The instances were stopped, msg from the ssm topic created with terraform"]
      }
    }
  }
}