variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    aws_region = null
    profile    = null
    cmsnet     = null
    bigmac_cidra = null
    bigmac_cidrb = null
  }
}