variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    aws_region = null
    nlb_ip_a   = null
    nlb_ip_b   = null
    appname    = null
    env        = null
    certdomain = null
  }
}