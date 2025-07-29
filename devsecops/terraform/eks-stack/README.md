# IAM Role
- Create IAM assume role arn:aws:iam::851725492879:role/lab-terraform-assume-role
- Replace external_id and assume_role in the provider.tf file 

```bash
aws configure
```

```bash
aws_session=$(aws sts assume-role --role-arn "arn:aws:iam::851725492879:role/lab-terraform-assume-role" --role-session-name "terraform-eks-session" --external-id "test-terraform")

export AWS_ACCESS_KEY_ID=$(echo $aws_session | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $aws_session | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $aws_session | jq -r '.Credentials.SessionToken')
```

# Run terraform scripts
```bash
bash ./scripts/setup_eks_stack.sh
```

# Destroy EKS stack
```bash
bash ./scripts/destroy_eks_stack.sh
```

# Clean up ENV variables
```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
```