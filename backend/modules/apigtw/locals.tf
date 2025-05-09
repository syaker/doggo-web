###################################################################
# Definición de recursos y métodos
###################################################################
locals {
  resources = {
    login = {
      path_part = "login"
      methods = {
        POST = {
          http_method   = "POST"
          authorization = "NONE"
        }
      }
    },
    register = {
      path_part = "register"
      methods = {
        POST = {
          http_method   = "POST"
          authorization = "NONE"
        }
      }
    },
    services = {
      path_part = "services"
      methods = {
        GET = {
          http_method   = "GET"
          authorization = "NONE"
        }
      }
    },
    messages = {
      path_part = "messages"
      methods = {
        POST = {
          http_method   = "POST"
          authorization = "NONE"
        },
        GET = {
          http_method   = "GET"
          authorization = "NONE"
        }
      }
    },
    sitters = {
      path_part = "sitters"
      methods = {
        GET = {
          http_method   = "GET"
          authorization = "NONE"
        }
      }
    },
    schedule = {
      path_part = "schedule"
      methods = {
        GET = {
          http_method   = "GET"
          authorization = "NONE"
        },
        POST = {
          http_method   = "POST"
          authorization = "NONE"
        }
      }
    }
  }
}