resource "kubernetes_namespace" "sourcegraph" {
  metadata {
    annotations = {
        name = "sourcegraph"
    }

    labels = {
      "name" = "sourcegraph"
      "app"  = "sourcegraph"
    }

    name = "sourcegraph"
  }
}