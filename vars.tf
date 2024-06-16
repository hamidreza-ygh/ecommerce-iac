variable "exo_secret_key" {
  description = "The secret key for the Exoscale provider"
  type = string
  default = "KNQup_XsHs9acWTI_G4sTShSW3OvGJ87fft9s9QLcbM"
  sensitive = true
}

variable "exo_api_key" {
  description = "The API key for the Exoscale provider"
  type = string
  default = "EXO42f5d868d6f0c3af6cdb0624"
  sensitive = true 
}

variable "cloudflare_email" {
  description = "The email address for the Cloudflare provider"
  type = string
  default = "hamidreza.ygh@gmail.com"
}

variable "cloudflare_api_key" {
  description = "The API key for the Cloudflare provider"
  type = string
  default = "8e1ee7c9362b612a25519a10cf893877594e5"
  sensitive = true 
}

variable "cloudflare_domain_zone_id" {
  description = "The Zone ID for the Cloudflare provider"
  type = string
  default = "bc0206a8813f315d41f3f2774fc0fad4"
  
}

variable "tenant_ui_domain" {
  description = "The domain name for the Tenant UI"
  type = string
  default = "tenantodo.life"
}

variable "user_management_repo_url" {
  description = "The URL for the user management repository"
  type = string
  default = "https://github.com/hamidreza-ygh/ecommerce-user-manager"
}

variable "user_interface_repo_url" {
  description = "The URL for the user management repository"
  type = string
  default = "https://github.com/hamidreza-ygh/ecommerce-ui"
}

variable "product_repo_url" {
  description = "The URL for the product repository"
  type = string
  default = "https://github.com/hamidreza-ygh/ecommerce-product"
}