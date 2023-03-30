pipeline {
    agent any
    
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        ANSIBLE_VAULT_SECRET = 'ansible-pass'
        KUBERNETES_INVENTORY = "./playbooks/inventory"
        //ANSIBLE_HOST_KEY_CHECKING = "False"
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
                        credentialsId: "github-ssh-key",
                        url: "git@github.com:lucasomena5/lucasomena5.git"             
                }
            }

        }

        // PIPELINE ACTION
        stage('Kubernetes Installation') {            
            steps{
                script {
                    echo "Install kubernetes - Master"
                    // ansiblePlaybook(
                    //         playbook: "./playbooks/KubernetesClusterInstallation.yml",
                    //         inventory: "${KUBERNETES_INVENTORY}",
                    //         colorized: true,
                    //         extras: "-b -v",   
                    // )
                    
                    
                }
            }
        }

        stage('Kubernetes Nodes Installation') {            
            steps{
                script {
                    echo "Install kubernetes - Nodes"
                    ansiblePlaybook(
                            playbook: "./playbooks/KubernetesNodesInstallation.yml",
                            inventory: "${KUBERNETES_INVENTORY}",
                            colorized: true,
                            extras: "-b -vvvv",   
                    )
                    
                    
                }
            }
        }
    }

}
