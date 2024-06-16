# Traefik deployment

resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  depends_on = [ kubernetes_namespace.traefik ]
  name             = "traefik"
  namespace = "traefik"
  repository       = "https://helm.traefik.io/traefik"
  chart            = "traefik"

  # Set Traefik as the default Ingress Controller
  set {
    name = "ingressClass.enabled"
    value = "true"
  }
  set {
    name = "ingressClass.isDefaultClass"
    value = "true"
  }

  # Redirect HTTP to HTTPS
  # set {
  #   name = "ports.web.redirectTo.port"
  #   value = "websecure"
  # }

  # # Enable tls on the websecure port
  # set {
  #   name = "ports.websecure.tls.enabled"
  #   value = "true"
  # }

  set {
    name = "service.annotations.service\\.beta\\.kubernetes\\.io/exoscale-loadbalancer-name"
    value = "traefik-nlb"
  }
}