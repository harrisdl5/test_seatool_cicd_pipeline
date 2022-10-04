variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    region       = null
    profile      = null
  }
}