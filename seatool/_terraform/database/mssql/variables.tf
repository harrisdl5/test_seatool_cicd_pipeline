variable "this" {
  description = "Map of project variables"
  type        = map(any)
  default = {
    aws_region = null
    profile    = null
    env        = null
    appname    = null
  }
}