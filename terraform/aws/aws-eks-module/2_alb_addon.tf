/* resource "null_resource" "eks_helm_charts" {
    provisioner "local-exec" {
        command = "helm repo add eks https://aws.github.io/eks-charts"
    }

  depends_on = [
    null_resource.initialize_kubectl
  ]
}

resource "null_resource" "eks_alb_charts" {
    provisioner "local-exec" {
        command = "kubectl apply -k 'github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master'"
    }

  depends_on = [
    null_resource.initialize_kubectl
  ]
}

resource "helm_release" "eks_helm_install_charts" {
  name         = "aws-load-balancer-controller"
  chart        = "eks/aws-load-balancer-controller"
  namespace    = "kube-system"
  
  set {
    name = "clusterName"
    value = "${aws_eks_cluster.eks.name}"
  }

  set {
    name = "serviceAccount.create"
    value = "false"
  }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [
    null_resource.initialize_kubectl
  ]
} */

####################################################################################################

/* data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["${join("-", ["subnet", "public", var.purpose, var.environment, "01"])}"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["${join("-", ["subnet", "public", var.purpose, var.environment, "02"])}"]
  }
}
resource "null_resource" "ig_ingress_v1" {
    provisioner "local-exec" {
        command = "kubectl apply -f ${templatefile("${path.module}/ingress/ig-ingress-v1.tftpl", 
        {
            SUBNET_1 = data.aws_subnet.subnet_1.id,
            SUBNET_2 = data.aws_subnet.subnet_2.id
        }
        )}"   
    }
    

  depends_on = [
    null_resource.initialize_kubectl
  ]
} */