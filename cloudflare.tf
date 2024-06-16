# Cloudflare DNS record and API token
resource "kubernetes_secret" "cloudflare_api_key_secret" {
  depends_on = [ kubernetes_namespace.certmanager ]
  metadata {
    name = "cloudflare-api-key-secret"
    namespace = "certmanager"
  }
  data = {
    "api-key" = var.cloudflare_api_key
  }
  type = "Opaque"
}

resource "cloudflare_record" "tenant_todo_life" {
  depends_on = [ kubernetes_secret.cloudflare_api_key_secret ]
  zone_id = var.cloudflare_domain_zone_id
  name = "tenantodo.life"
  value = data.exoscale_nlb.traefik_nlb.ip_address
  # value = exoscale_nlb.traefik_nlb.ip_address
  type =  "A"
  proxied = false
}

resource "cloudflare_record" "api_tenant_todo_life" {
  depends_on = [ kubernetes_secret.cloudflare_api_key_secret ]
  zone_id = var.cloudflare_domain_zone_id
  name = "api.tenantodo.life"
  value = data.exoscale_nlb.traefik_nlb.ip_address
  # value = exoscale_nlb.traefik_nlb.ip_address
  type =  "A"
  proxied = false
}

resource "cloudflare_record" "product_tenant_todo_life" {
  depends_on = [ kubernetes_secret.cloudflare_api_key_secret ]
  zone_id = var.cloudflare_domain_zone_id
  name = "product.tenantodo.life"
  value = data.exoscale_nlb.traefik_nlb.ip_address
  # value = exoscale_nlb.traefik_nlb.ip_address
  type =  "A"
  proxied = false
}

resource "cloudflare_record" "argocd_ui_tenant_todo_life" {
  depends_on = [ kubernetes_secret.cloudflare_api_key_secret ]
  zone_id = var.cloudflare_domain_zone_id
  name = "argocd.tenantodo.life"
  value = data.exoscale_nlb.traefik_nlb.ip_address
  # value = exoscale_nlb.traefik_nlb.ip_address
  type =  "A"
  proxied = false
}