resource "time_sleep" "wait_1_minute" {
  create_duration = "1m"
}

resource "kubernetes_service_account_v1" "aws-load-balancer-controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AmazonEKSLoadBalancerControllerRole"
    }
  }

  depends_on = [
    time_sleep.wait_1_minute
  ]
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  chart      = "eks/aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = "${aws_eks_cluster.eks.name}"
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [
    kubernetes_service_account_v1.aws-load-balancer-controller
  ]
}

resource "time_sleep" "wait_1_more_minute" {
  create_duration = "1m"

  depends_on = [ 
    helm_release.aws-load-balancer-controller
  ]
}

resource "null_resource" "metrics_server" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  }
  depends_on = [ 
    time_sleep.wait_1_more_minute
  ]
}
