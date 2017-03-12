resource "exoscale_affinity" "k8s-masters" {
    name = "k8s-masters"
}
resource "exoscale_affinity" "k8s-workers" {
    name = "k8s-workers"
}

resource "exoscale_compute" "k8s-master" {
  count = 1
  name = "k8s-master-${count.index}"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Small"
  diskSize = 10
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["k8s-master-sg"]
  affinitygroups = ["k8s-masters"]
}

resource "exoscale_compute" "k8s-worker" {
  count = 3
  name = "k8s-worker-${count.index}"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Small"
  diskSize = 10
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["k8s-worker-sg"]
  affinitygroups = ["k8s-workers"]
}

resource "exoscale_compute" "k8s-worker-disk" {
  count = 1
  name = "k8s-worker-disk-${count.index}"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Small"
  diskSize = 50
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["k8s-worker-sg"]
  affinitygroups = ["k8s-workers"]
}

resource "exoscale_compute" "k8s-worker-edge" {
  count = 2
  name = "k8s-worker-edge-${count.index}"
  template = "Linux Ubuntu 16.04 LTS 64-bit"
  zone = "ch-dk-2"
  size = "Small"
  diskSize = 10
  keypair = "patrick.recher@project-r.construction"
  userdata = ""
  securitygroups = ["k8s-worker-sg"]
  affinitygroups = ["k8s-workers"]
}

