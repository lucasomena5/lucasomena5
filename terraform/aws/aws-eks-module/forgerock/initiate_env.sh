#!/bin/bash

firstExecution() {
    if [ -e *.tfplan ]
    then
        rm -rf *terraform.tfstate* .terraform* *.tfplan *.pem ig.yml
    fi

    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform init"
    terraform init

    sleep 10

    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform plan"
    terraform plan -out forgerock.tfplan 

    sleep 10 

    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform apply"
    terraform apply "forgerock.tfplan"

    sleep 15 
}

secondExecution() {
    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform plan"
    terraform plan -out forgerock.tfplan 

    sleep 10 

    echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running terraform apply"
    terraform apply "forgerock.tfplan"
}

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running first function"
firstExecution

echo "[INFO] `date "+%Y-%m-%d %H:%M"` Running second function"
secondExecution