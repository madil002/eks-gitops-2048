resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.13.3"

  create_namespace = true
  namespace        = "ingress-nginx"

  values = [
    "${file("values/nginx-ingress.yaml")}"
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = "cert-manager"

  values = [
    "${file("values/cert-manager.yaml")}"
  ]

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    }
  ]
}
