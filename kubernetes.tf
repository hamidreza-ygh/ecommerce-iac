# locals {
#   endpoint = exoscale_sks_cluster.my_sks_cluster.endpoint
#   first_part = split(".", local.endpoint)[0]
#   domain_name = split(":", local.first_part)[0]
# }

resource "kubernetes_namespace" "control-tier" {
  metadata {
    name = "control-tier"
  }
}

resource "kubernetes_secret" "ui-secrets" {
  metadata {
    name = "ui-secrets"
    namespace = kubernetes_namespace.control-tier.metadata.0.name
  }

  data = {
    VUE_APP_BASE_URL = var.vue_app_base_url
    # VUE_APP_USER_API_URL = "${var.vue_app_user_api_url}.${split("//", split(".", exoscale_sks_cluster.my_sks_cluster.endpoint)[0])[1]}.cluster.local:3000"
    VUE_APP_USER_API_URL = var.vue_app_user_api_url
    VUE_APP_ECOMMERCE_PROVISION_URL = var.vue_app_tenant_provision_url
    VUE_APP_GH_TOKEN = var.vue_app_gh_token
    VUE_APP_CLUSTER_ENDPOINT = split("//", split(".", exoscale_sks_cluster.my_sks_cluster.endpoint)[0])[1]
    VUE_APP_PRODUCT_API_URL = var.vue_app_product_api_url
  }

  type = "Opaque"

  depends_on = [
    local_sensitive_file.my_sks_kubeconfig_file,
    kubernetes_namespace.control-tier
  ]
}

resource "kubernetes_secret" "user-manager-secrets" {
  metadata {
    name = "user-manager-secrets"
    namespace = kubernetes_namespace.control-tier.metadata.0.name
  }

  data = {
    ME_CONFIG_MONGODB_URL = var.me_config_mongodb_url
    JWT_SECRET = var.jwt_secret
  }

  type = "Opaque"

  depends_on = [
    local_sensitive_file.my_sks_kubeconfig_file,
    kubernetes_namespace.control-tier
  ]
}

resource "kubernetes_secret" "ecommerce-product-secrets" {
  metadata {
    name = "ecommerce-product-secrets"
    namespace = kubernetes_namespace.control-tier.metadata.0.name
  }

  data = {
    ME_CONFIG_MONGODB_URL = var.me_config_mongodb_product_url
  }

  type = "Opaque"

  depends_on = [
    local_sensitive_file.my_sks_kubeconfig_file,
    kubernetes_namespace.control-tier
  ]
}

# resource "kubernetes_yaml" "argocd-ui-ingress" {
#   metadata {
#     name = "argocd-ui-ingress"
#     namespace = "argocd"
#   }

#   yaml = file("${path.module}/argocd-ui-ingress.yaml")

#   depends_on = [
#     local_sensitive_file.my_sks_kubeconfig_file,
#     kubernetes_namespace.control-tier,
#     helm_release.argo_cd
#   ]
# }

resource "kubernetes_ingress_v1" "argocd-ui" {
  metadata {
    name = "argocd-ui"
    namespace = "argocd"
  }

  spec {
    rule {
      host = "argocd.tenantodo.life"
      http {
        path {
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }

          path = "/"
        }
      }
    }
  }
  depends_on = [
    local_sensitive_file.my_sks_kubeconfig_file,
    kubernetes_namespace.control-tier,
    helm_release.argo_cd
  ]
}