variable "this" {
  description = "Map of project variables"
  type        = map(any)

  default = {
    region       = null
    profile      = null
    inst_count   = null
    inst_type    = null
    key_name     = null
    backup       = null
    patchgroup   = null
    ami_owner    = null
    ami_value    = null
    ami_id       = null
    prefix       = null
    hostname-a   = null
    hostname-b   = null
    hostname-c   = null
    vol_size     = null
    vol_type     = null
    sec_vol_size = null
    sec_vol_type = null
    lb_port_a    = null
  }
}