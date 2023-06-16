#!/bin/bash

if [ -e *.tfplan ]
then
    rm -rf *terraform.tfstate*
    rm -rf .terraform*
    rm -rf *.tfplan
    rm -rf *.pem
    rm -rf ig.yml
fi

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform init"
terraform init

sleep 10

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform plan"
terraform plan -out forgerock.tfplan 

sleep 10 

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform apply"
terraform apply "forgerock.tfplan"