# INSTALL DRIVERS
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --set syncSecret.enabled=true
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

# SECRETS
aws --region us-east-1 secretsmanager  create-secret --name openig-secrets-env  --secret-string '{"user":"password"}' --profile lab-aws

aws iam create-policy --policy-name aws-eks-secrets-manager-policy --policy-document file://secrets-manager-policy.json --profile lab-aws

cat >ig-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ig-service-account
  namespace: default
EOF
kubectl apply -f ig-service-account.yaml

account_id=$(aws sts get-caller-identity --query "Account" --output text --profile lab-aws)
oidc_provider=$(aws eks describe-cluster --profile lab-aws --name eks-forgerock-lab-01 --region us-east-1 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

export namespace=default
export service_account=ig-service-account

cat >trust-relationship.json <<EOF
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
          "$oidc_provider:sub": "system:serviceaccount:$namespace:$service_account"
        }
      }
    }
  ]
}
EOF

aws iam create-role --role-name csi-eks-secrets-manager-role --profile lab-aws --assume-role-policy-document file://trust-relationship.json --description "AWS EKS Intregation with Secrets Manager"

aws iam attach-role-policy --role-name csi-eks-secrets-manager-role --policy-arn=arn:aws:iam::$account_id:policy/aws-eks-secrets-manager-policy --profile lab-aws

##
aws iam attach-role-policy --role-name csi-eks-secrets-manager-role --policy-arn=arn:aws:iam::$account_id:policy/csi-secrets-store-provider-aws-cluster-policy --profile lab-aws
##

kubectl annotate serviceaccount -n $namespace $service_account eks.amazonaws.com/role-arn=arn:aws:iam::$account_id:role/csi-eks-secrets-manager-role