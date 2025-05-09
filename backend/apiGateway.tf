
module "api" {
  source = "./modules/apigtw"

  api_name = var.api_name
  region   = var.region
  lambda_functions = {
    login    = local.lambda_functions["doggo-login-lambda"].invoke_arn
    register = local.lambda_functions["doggo-register-lambda"].invoke_arn
    services = local.lambda_functions["doggo-service-lambda"].invoke_arn
    messages = local.lambda_functions["doggo-message-lambda"].invoke_arn
    sitters  = local.lambda_functions["doggo-sitters-lambda"].invoke_arn
    schedule = local.lambda_functions["doggo-schedule-lambda"].invoke_arn
  }
}