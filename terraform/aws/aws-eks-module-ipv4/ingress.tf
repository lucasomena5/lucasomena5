resource "time_sleep" "wait_1_minute" {
  create_duration = "1m"

  depends_on = [ 
    null_resource.initialize_kubectl
  ]
}

resource "kubernetes_service_account_v1" "sa_aws_load_balancer_controller" {
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

resource "helm_release" "aws_load_balancer_controller" {
  name      = "aws-load-balancer-controller"
  chart     = "eks/aws-load-balancer-controller"
  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks.name
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
    kubernetes_service_account_v1.sa_aws_load_balancer_controller
  ]
}

resource "time_sleep" "wait_1_more_minute" {
  create_duration = "1m"

  depends_on = [
    helm_release.aws_load_balancer_controller
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

resource "local_file" "ig_file" {
  content = templatefile("${path.module}/ig.tpl", {
    ACM_CERTIFICATE_ARN = aws_acm_certificate.cert.arn
    IMAGE_ID            = "gcr.io/forgerock-io/ig@sha256:f98027c534652a9356e796b541e9c460f47db9a96c5733fcae6cdabb40ca9b7d"
  })
  filename = "${path.module}/ig.yml"

  depends_on = [ 
    aws_acm_certificate.cert,
    null_resource.metrics_server
  ]
}

/* resource "null_resource" "ig" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/ig.yml"
  }
  depends_on = [
    local_file.ig_file,
    null_resource.metrics_server
  ]
} */
