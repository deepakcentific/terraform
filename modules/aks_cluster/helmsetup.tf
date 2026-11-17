provider "helm" {
  kubernetes = {
    host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config[0].cluster_ca_certificate)
}

resource "helm_release" "nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  create_namespace = true
  set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
      value = "/healthz"
    }
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster
  ]
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [
    helm_release.nginx,
  ]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true

  #This is required to run the argocd without https through nginx. 
  #If ssl is setup is there then it can commented.
  set = [
    {
      name  = "configs.params.server\\.insecure"
      value = "true"
    }
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks_cluster
  ]
}