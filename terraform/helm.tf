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
