variable "application" {
  description = "Name of the application"
  type        = string
  default     = "seatool" # replace with your app name
}

variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    environment = null
    aws_region  = null
    key_name    = null
  }
}
