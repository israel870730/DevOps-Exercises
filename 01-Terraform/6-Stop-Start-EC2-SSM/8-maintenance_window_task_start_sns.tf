# En este fichero definimos todas las tareas de la ventana de mantenimiento START
# en este caso vamos a definir una tarea para iniciar las instancias y otra para enviar un mail con la notificacion
resource "aws_ssm_maintenance_window_task" "maintenance_window_start_App1" {
  name            = "maintenance_window_start_App1"
  description     = "Task to start the group of EC2 instances App1"
  max_concurrency = 2
  max_errors      = 1
  priority        = 1
  task_arn        = "AWS-StartEC2Instance"
  task_type       = "AUTOMATION"
  window_id       = aws_ssm_maintenance_window.maintenance_window_start_App1.id
  service_role_arn = aws_iam_role.Start_Stop_EC2_SSM.arn
  targets {
    #Aqui le paso el target 
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.maintenance_window_target_start_App1.id]
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

resource "aws_ssm_maintenance_window_task" "maintenance_window_task_start_sns" {
  name            = "maintenance_window_task_start_sns"
  description     = "Send a SNS msg start EC2"
  priority        = 20
  task_arn        = "AWS-PublishSNSNotification"
  task_type       = "AUTOMATION"
  window_id       = aws_ssm_maintenance_window.maintenance_window_start_App1.id
  service_role_arn = aws_iam_role.Start_Stop_EC2_SSM.arn

  task_invocation_parameters {
    automation_parameters {
      document_version = "$LATEST"
      #Aqui se le pasa los parametros que lleva la funcion
      parameter {
        name   = "TopicArn"
        values = [aws_sns_topic.topic_sns_ssm.arn]
      }
      parameter {
        name   = "Message"
        values = ["The instances were started, msg from the ssm topic created with terraform"]
      }
    }
  }
}
