variable "user_tags" {
  description = "Mandatory tags for the api-gateway resources"
  type        = map(string)
}

variable "octopus_tags" {
  description = "Octopus Tags"
  type        = map(string)
}

variable "name" {
  description = "The name of the API Gateway that has to be created"
  type        = string
}

variable "description" {
  description = "The description of the API Gateway"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC to create the API Gateway in. If it is empty, then cluster will be created in `default-vpc`"
  default     = ""
}

variable "domain" {
  description = "The domain name for the API Gateway"
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the API Gateway"
  type        = string
}

variable "protocol_type" {
  description = "The API Gateway protocol type, only HTTP is supported currently"
  type        = string
  default     = "HTTP"
}

variable "cors_configuration" {
  description = "The CORS config for the API Gateway"
  type        = any
  default     = {}
}

variable "default_route_settings" {
  description = "The default route settings for the API Gateway"
  type        = map(string)
  default     = {}
}

variable "integrations" {
  description = "The map of integrations for the API Gateway"
  type        = map(any)
  default     = {}
}

variable "authorizer_audience" {
  description = "The authorizer audience"
  type        = string
}

variable "authorizer_issuer" {
  description = "The authorizer issuer"
  type        = string
}
