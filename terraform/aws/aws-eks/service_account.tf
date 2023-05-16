/* resource "kubernetes_service_account_v1" "aws-load-balancer-controller" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
        "eks.amazonaws.com/role-arn" = "${aws_iam_role.loadbalancer_role.arn}"
    }
    labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }  
  }

  depends_on = [
    null_resource.initialize_kubectl
  ]
} */