locals {
  lambda_functions = {
    "login" = {
      handler     = "index.handler"
      source_path = "./src/function/login"
    },
    "register" = {
      handler     = "index.handler"
      source_path = "./src/function/register"
    },
    "service" = {
      handler     = "index.handler"
      source_path = "./src/function/service"
    },
    "message-send" = {
      handler     = "index.handler"
      source_path = "./src/function/message_send"
    },
    "message-obtain" = {
      handler     = "index.handler"
      source_path = "./src/function/message_obtain"
    },
    "sitters" = {
      handler     = "index.handler"
      source_path = "./src/function/sitters"
    },
    "schedule" = {
      handler     = "index.handler"
      source_path = "./src/function/schedule"
    },
    "schedule-obtain" = {
      handler     = "index.handler"
      source_path = "./src/function/schedule_obtain"
    }
  }

  lambda_layers = {
    PyMySQL = {
      layer_name          = "PyMySQL-1.1.1"
      description         = "Layer for PyMySQL"
      compatible_runtimes = ["python3.13"]
      source_path         = "./src/function_layer/PyMySQL-1.1.1.zip"
    }
  }

  tags = {
    "Environment" = "PRD"
    "Project"     = "doggo"
    "Grupo"       = "1"
  }
}
