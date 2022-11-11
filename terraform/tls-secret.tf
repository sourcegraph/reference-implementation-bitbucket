resource "kubernetes_secret" "ingress-tls" {
    depends_on = [
      kubernetes_namespace.sourcegraph
    ]
    metadata {
        name      = "sourcegraph-tls"
        namespace = "sourcegraph"
    }

    data = {
        "tls.key" = file("./resources/tls.key")
        "tls.crt" = file("./resources/tls.crt")
    }

    type = "kubernetes.io/tls"
}