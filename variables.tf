variable "access_key" {
  type = string
  description = "access key to aws"
}
variable "secret_key" {
  type = string
  description = "secret key to aws"
}
variable "region" {
  type = string
  description = "region on aws"
}
variable "filename" {
  type = string
  description = "filename for the lambda function"
}
variable "function_name" {
  type = string
  description = "function name for the lambda function"
}
variable "handler" {
  type = string
  description = "handler to use for the lambda"
}
variable "tag" {
  type = string
  description = "the tag name that gets checked to publish an object"
}
variable "tag_value" {
  type = string
  description = "the value of the given tag to publish an object"
}
variable "object_key" {
  type = string
  description = "the key the object will be stored under"
}
variable "object_source" {
  type = string
  description = "the source where to find the object"
}

