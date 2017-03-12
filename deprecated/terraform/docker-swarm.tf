resource "exoscale_affinity" "docker-managers" {
    name = "docker-managers"
}
resource "exoscale_affinity" "docker-workers" {
    name = "docker-workers"
}

resource "exoscale_compute" "docker-manager" {
  count = 3
  name = "docker-manager-${count.index}"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Tiny"
  diskSize = 10
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["production"]
  affinitygroups = ["docker-managers"]
}

resource "exoscale_compute" "docker-worker" {
  count = 1
  name = "docker-worker-${count.index}"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Tiny"
  diskSize = 10
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["production"]
  affinitygroups = ["docker-workers"]
}
