locals {
  lambda_functions = {
    login-lambda = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/login"
    },
    register-lambda = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/register"
    },
    service-lambda = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/service"
    },
    message-lambda = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/message"
    },
    sitters-lambda = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/sitters"
    },
    schedule-lambda = {
      handler     = "index.lambda_handler"
      runtime     = "python3.13"
      source_path = "./src/function/schedule"
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