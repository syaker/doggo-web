module "api" {
  source                          = "./modules/apigtw"
  create_rest_api                 = true
  rest_api_name                   = "doggo-api"
  endpoint_type                   = "REGIONAL"
  logging_level                   = "ERROR"
  stage                           = "api"
  cloudwatch_log_group_name       = "doggo-api-logs"
  default_throttling_burst_limit  = 100
  default_throttling_rate_limit   = 300
  timeout_milliseconds            = [28800]

  openapi_config = {
    openapi = "3.0.1"
    info = {
      title   = "${var.env}-${var.project}-api"
      version = "1.0"
    }
    paths = {
      "/login" = {
        post = {
          summary = "Login"
          description = "Para iniciar sesión con correo y contraseña"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-login/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
      }
      "/register" = {
        post = {
          summary = "Register"
          description = "Registrar usuario con su email, contraseña y un checkbox para aceptar terminos y condiciones"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-register/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
      }
      "/services" = {
        get = {
          summary = "Obtener servicios"
          description = "Obtiene los servicios y la promo del dia para mostrarla en el home"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-service-obtain/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
      }
      "/messages" = {
        get = {
          summary = "Obtener mensajes"
          description = "Obtener los mensajes del usuario"

          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-message-obtain/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        },
        post = {
          summary = "Enviar mensaje"
          description = "Enviar un mensaje y guardarlo en la base de datos"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-message-send/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
      }
      "/sitters" = {
        get = {
          summary = "Obtener cuidadores"
          description = "Obtener los cuidadores disponibles"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-sitters/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
      }
      "/schedule/{sitterId}" = {
        get = {
          summary = "Obtener horarios"
          description = "Obtener agenda disponible del cuidador"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-schedule-obtain/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
        post = {
          summary = "Agendar horario"
          description = "Agendar una cita con el cuidador"
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            uri        = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:611415883004:function:doggo-schedule/invocations"
            timeoutInMillis     = 29000
            type                = "AWS_PROXY"
          }
        }
      }
    }
  }

  resource_tags_mandatory = {
    ENV          = var.env
  }

}