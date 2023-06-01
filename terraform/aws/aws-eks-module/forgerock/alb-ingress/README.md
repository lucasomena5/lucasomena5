# ALB
Install ALB (Installing the AWS Load Balancer Controller add-on - Amazon EKS)

1)	IAM policy
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json --profile lab-aws

2)	IAM role
account_id=$(aws sts get-caller-identity --query "Account" --output text --profile lab-aws)

oidc_provider=$(aws eks describe-cluster --profile lab-aws --name eks-forgerock-lab-01 --region us-east-1 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

cat >load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "$oidc_provider:aud": "sts.amazonaws.com",
                    "$oidc_provider:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF

aws iam create-role \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --assume-role-policy-document file://"load-balancer-role-trust-policy.json" \
  --profile lab-aws

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::030584239866:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole --profile lab-aws 

cat >aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::`aws sts get-caller-identity --query "Account" --output text --profile lab-aws`:role/AmazonEKSLoadBalancerControllerRole
EOF

kubectl apply -f aws-load-balancer-controller-service-account.yaml

# INGRESS CONTROLLER
helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=eks-forgerock-lab-01 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Identity Provider 
Create Identity Provider OpenID

# CNI 
account_id=$(aws sts get-caller-identity --query "Account" --output text --profile lab-aws)

oidc_provider=$(aws eks describe-cluster --profile lab-aws --name eks-forgerock-lab-01 --region us-east-1 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

cat >vpc-cni-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "$oidc_provider:aud": "sts.amazonaws.com",
                    "$oidc_provider:sub": "system:serviceaccount:kube-system:aws-node"
                }
            }
        }
    ]
}
EOF

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::416656901077:policy/AmazonEKS_CNI_IPv6_Policy \
  --role-name AmazonEKSVPCCNIRole --profile lab-aws

kubectl annotate serviceaccount \
    -n kube-system aws-node \
    eks.amazonaws.com/role-arn=arn:aws:iam::416656901077:role/AmazonEKSVPCCNIRole


# AUTOSCALE

# Set optional environment variables
export AWS_PROFILE="lab-aws"
export AWS_REGION="us-east-1"
export ACCOUNT_ID=$(aws sts get-caller-identity --output json --profile lab-aws | jq ".Account" | tr -d '"')

# Set common environment variables
export TARGET_GROUP_NAME="locust" 
export TARGET_CLUSTER_NAME="eks-${TARGET_GROUP_NAME}-lab-01"
export TARGET_REGION="${AWS_REGION}"

# Check
cat <<EOF
_______________________________________________
* AWS_PROFILE : ${AWS_PROFILE:-(default)}
* AWS_REGION  : ${AWS_REGION:-(invalid!)}
* ACCOUNT_ID  : ${ACCOUNT_ID:-(invalid!)}
_______________________________________________
* TARGET_GROUP_NAME   : ${TARGET_GROUP_NAME}
* TARGET_CLUSTER_NAME : ${TARGET_CLUSTER_NAME}
* TARGET_REGION       : ${TARGET_REGION:-(invalid!)}
EOF

cat >"${CA}".yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "${CA}"
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::$ACCOUNT_ID:role/"${TARGET_CLUSTER_NAME}-${CA}"
EOF

aws iam create-role \
  --role-name "${TARGET_CLUSTER_NAME}-${CA}" \
  --assume-role-policy-document file://"cluster_autoscaler_autoDiscovery.json" \
  --profile lab-aws