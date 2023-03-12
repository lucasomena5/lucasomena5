pipeline {
    agent any
    
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
        ANSIBLE_VAULT_SECRET = 'ansible-pass'
        KUBERNETES_INVENTORY = "./playbooks/inventory"
    }
    
    // parameters {

    //     // CHOICES 
    //     choice(name: 'SITE', choices: [
    //         'NONE',
    //         'MONTREAL_TO_OREGON', 
    //         'OREGON_TO_MONTREAL'
    //     ],
    //     description: 'Select primary region:')

    //     // CHOICES
    //     choice(name: 'ACTION', choices: [
    //         'NONE',
    //         'GALERA_ENABLER',
    //         'SWITCHOVER',
    //         'FAILOVER',
    //         'FAILOVER_FORCED',
    //         'FAILBACK'
    //     ],
    //     description: 'What action is required?')        

    // }
    
    // PIPELINE OPTIONS
    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    // PIPELINE ACTION
    stages {

        // PIPELINE ACTION
        stage('Kubernetes Installation') {
            when {}
            
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

        // PIPELINE ACTION - NONE
        stage('NONE') {
            when {
                expression {
                    params.ACTION == 'NONE' || params.SITE == 'NONE'
                }
            }

            steps {
                sh "echo 'SITE SELECTED: ${params.SITE}'"
                sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                sh "echo 'Do nothing when selecting ${params.SITE} or ${params.ACTION}'"
            }
        }
    } // STAGES ENDS
    

    post {
        success {
            echo "STAGE ${params.ACTION} SUCCESSFULLY"
        }
        failure {
            echo "STAGE ${params.ACTION} FAIL"
        }
        changed {
            echo "PIPELINE HAS CHANGED"
        }
    } // POST END

} // THE END
