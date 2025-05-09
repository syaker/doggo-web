# Definición de variables
variable "region" {
  description = "Región de AWS"
  type        = string
}

variable "api_name" {
  description = "Nombre de la API Gateway"
  type        = string
}
variable "lambda_functions" {
  description = "Mapeo de funciones Lambda para cada recurso"
  type        = map(string)

}