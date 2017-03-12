resource "exoscale_compute" "monitor" {
  name = "monitor"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Small"
  diskSize = 50
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["production"]
}
