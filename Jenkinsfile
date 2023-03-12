pipeline {
    agent any
    
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
        ANSIBLE_VAULT_SECRET = 'ansible-pass'
        KUBERNETES_INVENTORY = "./playbooks/inventory"
    }

    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    // PIPELINE ACTION
    stages {

        stage('Checkout') {
            steps {
                script {
                    git branch: "release/ansible",
                        credentialsId: "jenkins",
                        url: "git@github.com:lucasomena5/lucasomena5.git"             
                }
            }

        }

        // PIPELINE ACTION
        stage('Kubernetes Installation') {            
            steps{
                script {

                    ansiblePlaybook(
                            playbook: "./playbooks/KubernetesClusterInstallation.yml",
                            inventory: "${KUBERNETES_INVENTORY}",
                            colorized: true,
                            extras: "-b",   
                    )
                    
                    
                }
            }
        }
    }

}
