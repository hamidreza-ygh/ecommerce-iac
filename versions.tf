terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.54.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0"
    }
  }
}

# provider "kubernetes" {
#   config_path = local_sensitive_file.my_sks_kubeconfig_file.filename
# }


provider "exoscale" {
  key = var.exo_api_key
  secret = var.exo_secret_key
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig"
  }
}

provider "kubernetes" {
  host = exoscale_sks_cluster.my_sks_cluster.endpoint

  client_certificate = "${base64decode(yamldecode(exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig).users[0].user.client-certificate-data)}"
  client_key         = "${base64decode(yamldecode(exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig).users[0].user.client-key-data)}"
  cluster_ca_certificate = "${base64decode(yamldecode(exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig).clusters[0].cluster.certificate-authority-data)}"
  
}

provider "kubectl" {
  host = exoscale_sks_cluster.my_sks_cluster.endpoint

  client_certificate = "${base64decode(yamldecode(exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig).users[0].user.client-certificate-data)}"
  client_key         = "${base64decode(yamldecode(exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig).users[0].user.client-key-data)}"
  cluster_ca_certificate = "${base64decode(yamldecode(exoscale_sks_kubeconfig.my_sks_kubeconfig.kubeconfig).clusters[0].cluster.certificate-authority-data)}"

  load_config_file = false
}

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}