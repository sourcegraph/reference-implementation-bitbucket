resource "helm_release" "aws-load-balancer-controller" {
    depends_on = [module.eks, aws_iam_role_policy_attachment.additional]
    name       = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts/"
    chart      = "aws-load-balancer-controller"
    namespace  = "kube-system"

    set {
        name  = "clusterName"
        value = module.eks.cluster_id
    }
    
    set {
        name  = "serviceAccount.name"
        value = "aws-load-balancer-controller"
    }
    set {
        name  = "serviceAccount.create"
        value = "false"
    }
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = "${module.eks.cluster_id}"
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = "${var.region}"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "sslCertPath"
    value = "/etc/ssl/certs/ca-certificates.crt"
  }

  set {
    name  = "rbac.serviceACcount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.autoscaler_role.arn}"
  }
  set {
    name  = "rbac.serviceACcount.name"
    value = "cluster-autoscaler"
  }
}


resource "helm_release" "sourcegraph_local_chart" {
  count = var.use_remote_charts == false ? 1 : 0
  ### Wait for ALB controller before          ###
  ### installing Sourcegraph and an ingress   ###
  depends_on       = [module.eks, aws_iam_role_policy_attachment.additional, aws_eks_addon.addons, helm_release.cluster_autoscaler, helm_release.aws-load-balancer-controller]
  name             = "sourcegraph"
  chart            = "./resources/chart/sourcegraph"
  namespace        = "sourcegraph"
  version          = var.sourcegraph_version
  values           = [
      "${file("./resources/override.yaml")}"
  ]

  set {
    name  = "frontend.ingress.tlsSecret"
    value = "sourcegraph-tls"
  }
}

resource "helm_release" "sourcegraph_remote_chart" {
  count = var.use_remote_charts ? 1 : 0
  ### Wait for ALB controller before          ###
  ### installing Sourcegraph and an ingress   ###
  depends_on       = [module.eks, aws_iam_role_policy_attachment.additional, aws_eks_addon.addons, helm_release.cluster_autoscaler, helm_release.aws-load-balancer-controller]
  name             = "sourcegraph"
  repository       = "https://helm.sourcegraph.com/release"
  chart            = "sourcegraph"
  namespace        = "sourcegraph"
  version          = var.sourcegraph_version
  values           = [
      "${file("./resources/override-remote.yaml")}"
  ]

  set {
    name  = "frontend.ingress.tlsSecret"
    value = "sourcegraph-tls"
  }
}