locals {
  lambda_functions = {
    "doggo-login-lambda" = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/login"
      invoke_arn  = "arn:aws:lambda:eu-west-1:611415883004:function:doggo-login-lambda:invoke"
    },
    "doggo-register-lambda" = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/register"
      invoke_arn  = "arn:aws:lambda:eu-west-1:611415883004:function:doggo-register-lambda:invoke"
    },
    "doggo-service-lambda" = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/service"
      invoke_arn  = "arn:aws:lambda:eu-west-1:611415883004:function:doggo-service-lambda:invoke"
    },
    "doggo-message-lambda" = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/message"
      invoke_arn  = "arn:aws:lambda:eu-west-1:611415883004:function:doggo-message-lambda:invoke"
    },
    "doggo-sitters-lambda" = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/sitters"
      invoke_arn  = "arn:aws:lambda:eu-west-1:611415883004:function:doggo-sitters-lambda:invoke"
    },
    "doggo-schedule-lambda" = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/schedule"
      invoke_arn  = "arn:aws:lambda:eu-west-1:611415883004:function:doggo-schedule-lambda:invoke"
    }
  }

  lambda_layers = {
    PyMySQL = {
      layer_name          = "PyMySQL-1.1.1"
      description         = "Layer for PyMySQL"
      compatible_runtimes = ["python3.13"]
      source_path         = "./src/function_layer/PyMySQL-1.1.1.zip"
    },
    PySQLServer = {
      layer_name          = "PySQLServer-1.0.0"
      description         = "Layer for PySQLServer"
      compatible_runtimes = ["python3.13"]
      source_path         = "./src/function_layer/PySQLServer-1.0.0.zip"
    }
  }

  tags = {
    "Environment" = "PRD"
    "Project"     = "doggo"
    "Grupo"       = "1"
  }
}
