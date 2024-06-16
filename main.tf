locals {
  zone = "at-vie-2"
}

resource "exoscale_security_group" "my_security_group" {
  name = "my-sks-cluster-sg"
}

resource "exoscale_security_group_rule" "kubelet" {
  security_group_id = exoscale_security_group.my_security_group.id
  description       = "Kubelet"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 10250
  end_port          = 10250
  # (beetwen worker nodes only)
  user_security_group_id = exoscale_security_group.my_security_group.id
}

resource "exoscale_security_group_rule" "cilium_vxlan" {
  security_group_id = exoscale_security_group.my_security_group.id
  description       = "Cilium VXLAN"
  type              = "INGRESS"
  protocol          = "UDP"
  start_port        = 8472
  end_port          = 8472
  user_security_group_id = exoscale_security_group.my_security_group.id
}

resource "exoscale_security_group_rule" "cilium_health" {
  security_group_id = exoscale_security_group.my_security_group.id
  description       = "Cilium Health Check"
  type              = "INGRESS"
  protocol          = "ICMP"
  icmp_code         = 0
  icmp_type         = 8
  user_security_group_id = exoscale_security_group.my_security_group.id
}

resource "exoscale_security_group_rule" "cilium_health_tcp" {
  security_group_id = exoscale_security_group.my_security_group.id
  description       = "Cilium Health Check"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 4240
  end_port          = 4240
  user_security_group_id = exoscale_security_group.my_security_group.id
}

resource "exoscale_sks_cluster" "my_sks_cluster" {
   zone = local.zone
   name = "my-sks-cluster"
   cni = "cilium"
}

# (administration credentials)
resource "exoscale_sks_kubeconfig" "my_sks_kubeconfig" {
  zone       = local.zone
  cluster_id = exoscale_sks_cluster.my_sks_cluster.id
  user   = "kubernetes-admin"
  groups = ["system:masters"]
  ttl_seconds           = 3600
  early_renewal_seconds = 300
}
resource "local_sensitive_file" "my_sks_kubeconfig_file" {
  filename        = "kubeconfig"
  content         = exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig
  file_permission = "0600"
}
resource "exoscale_sks_nodepool" "my_sks_nodepool" {
  zone       = local.zone
  cluster_id = exoscale_sks_cluster.my_sks_cluster.id
  name       = "my-sks-nodepool"
  instance_type = "standard.medium"
  size          = 2
  security_group_ids = [
    exoscale_security_group.my_security_group.id,
  ]
}

data "exoscale_nlb" "traefik_nlb" {
  depends_on = [ helm_release.traefik ]
  zone = local.zone
  name = "traefik-nlb"
}

data "exoscale_nlb_service_list" "traefik_nlb_services" {
  depends_on = [
    helm_release.traefik,
    data.exoscale_nlb.traefik_nlb
  ]
  zone = local.zone
  nlb_name = "traefik-nlb"
}

resource "exoscale_security_group_rule" "http_tcp" {
  depends_on = [ data.exoscale_nlb_service_list.traefik_nlb_services ]
  security_group_id = exoscale_security_group.my_security_group.id
  description       = "HTTP"
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 80
  end_port          = [for service in data.exoscale_nlb_service_list.traefik_nlb_services.services : service.target_port if service.port == 80][0]
}

resource "exoscale_security_group_rule" "https_tcp" {
  depends_on = [ data.exoscale_nlb_service_list.traefik_nlb_services ]
  security_group_id = exoscale_security_group.my_security_group.id
  description       = "HTTPS"
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 443
  end_port          = [for service in data.exoscale_nlb_service_list.traefik_nlb_services.services : service.target_port if service.port == 443][0]
}

# resource "exoscale_nlb" "traefik_nlb" {
#   depends_on = [ helm_release.traefik ]
#   name = "traefik-nlb"
#   zone = local.zone
# }
