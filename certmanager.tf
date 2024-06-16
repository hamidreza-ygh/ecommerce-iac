resource "kubernetes_namespace" "certmanager" {
  metadata {
    name = "certmanager"
  }
}

# resource "helm_release" "certmanager" {
#   depends_on = [
#     local_sensitive_file.my_sks_kubeconfig_file,
#     exoscale_sks_nodepool.my_sks_nodepool,
#     kubernetes_namespace.certmanager
#   ]
#   name             = "certmanager"
#   repository       = "https://charts.jetstack.io"
#   chart            = "cert-manager"
#   version          = "v1.5.3"
#   timeout          = 1200
#   create_namespace = true
#   namespace        = "certmanager"
#   lint             = true
#   wait             = true

#   # Install Kubernetes CRDs
#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
# }

# resource "time_sleep" "wait_for_certmanager" {
#   depends_on = [ helm_release.certmanager ]
#   create_duration = "10s"
# }

# # Create Cluster Issuer
# resource "kubectl_manifest" "cloudflare_prod" {
#   depends_on = [ time_sleep.wait_for_certmanager, kubernetes_secret.cloudflare_api_key_secret ]
#   yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: cloudflare-prod
# spec:
#   acme:
#     email: ${var.cloudflare_email}
#     server: https://acme-staging-v02.api.letsencrypt.org/directory
#     privateKeySecretRef:
#       name: cloudflare-prod-account-key
#     solvers:
#     - dns01:
#         cloudflare:
#           email: ${var.cloudflare_email}
#           apiKeySecretRef:
#             name: cloudflare-api-key-secret
#             key: api-key
# YAML
# }

# resource "time_sleep" "wait_for_clusterissuer" {
#   depends_on = [ kubectl_manifest.cloudflare_prod ]
#   create_duration = "50s"
# }


