pipeline {
    agent any
    
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'false'
        ANSIBLE_VAULT_SECRET = 'ansible-pass'

        // ENVIRONMENT VARIABLES - MONTREAL
        SITE_1 = 'montreal'
        CLUSTER_ID_MONTREAL = 'avs66-prepr'
        ANSIBLE_USER_MONTREAL = 'lucasomena'
        MONTREAL_VAULT_PASSWORD_FILE_PATH = "/product/tmp/pass"
        MONTREAL_INVENTORY = "./geo-redundancy/Dynamic_Inventory/test-geo/inventory/montreal/inventory"
        
        // ENVIRONMENT VARIABLES - OREGON
        SITE_2 = 'oregon'
        CLUSTER_ID_OREGON = 'avs66-preprod'
        ANSIBLE_USER_OREGON = 'lucasomena'
        OREGON_VAULT_PASSWORD_FILE_PATH = "/product/tmp/pass"
        OREGON_INVENTORY = "./geo-redundancy/Dynamic_Inventory/test-geo/inventory/oregon/inventory"
    }
    
    parameters {

        // CHOICES 
        choice(name: 'SITE', choices: [
            'NONE',
            'MONTREAL_TO_OREGON', 
            'OREGON_TO_MONTREAL'
        ],
        description: 'Select primary region:')

        // CHOICES
        choice(name: 'ACTION', choices: [
            'NONE',
            'GALERA_ENABLER',
            'SWITCHOVER',
            'FAILOVER',
            'FAILOVER_FORCED',
            'FAILBACK'
        ],
        description: 'What action is required?')        

    }
    
    // PIPELINE OPTIONS
    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '20'))
    }

    // PIPELINE ACTION
    stages {
        
        stage('CHECKOUT') {
            steps {
                script {
                    git branch: "master",
                        credentialsId: "github-ssh-key",
                        url: "git@github.com:lucasomena5/personal-jenkins-lab.git"             
                }
            }

        }

        // PIPELINE ACTION
        stage('GALERA ENABLER') {
            when {
                expression {
                    params.SITE == 'MONTREAL_TO_OREGON' || params.SITE == 'OREGON_TO_MONTREAL' 
                }
                expression {
                    params.ACTION == 'GALERA_ENABLER'
                }
            }
            
            steps{
                script {
                    if (params.SITE == 'MONTREAL_TO_OREGON') {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"

                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"
                       
                        // ENVIRONMENT VARIABLES - OREGON 
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/GaleraClusterEnable.yml",
                            inventory: "${MONTREAL_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            extras: "-b --vault-password-file=${MONTREAL_VAULT_PASSWORD_FILE_PATH}",   
                        )

                    } else {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"

                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"
                        
                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/GaleraClusterEnable.yml",
                            inventory: "${OREGON_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            extras: "-b --vault-password-file=${OREGON_VAULT_PASSWORD_FILE_PATH}",   
                        )
                    
                    }
                }
            }
        }

        // PIPELINE ACTION - SWITCHOVER
        stage('SWITCHOVER') {
            when {
                expression {
                    params.SITE == 'MONTREAL_TO_OREGON' || params.SITE == 'OREGON_TO_MONTREAL' 
                }
                expression {
                    params.ACTION == 'SWITCHOVER'
                }
            }

            steps {
                script {
                    if (params.SITE == 'MONTREAL_TO_OREGON') {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                        
                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"
                        
                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/SwitchoverGalera.yml",
                            inventory: "${MONTREAL_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${MONTREAL_VAULT_PASSWORD_FILE_PATH}",   
                        )  

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/SwitchoverMaxScaleDC1.yml",
                            inventory: "${MONTREAL_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${MONTREAL_VAULT_PASSWORD_FILE_PATH}",   
                        )   

                    } else {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                        
                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"
                        
                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/SwitchoverGalera.yml",
                            inventory: "${OREGON_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${OREGON_VAULT_PASSWORD_FILE_PATH}",   
                        )

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/SwitchoverMaxScaleDC2.yml",
                            inventory: "${OREGON_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${OREGON_VAULT_PASSWORD_FILE_PATH}",   
                        )

                    }
                }
            }
        }   
        
        // PIPELINE ACTION - FAILOVER
        stage('FAILOVER') {
            when {
                expression {
                    params.SITE == 'MONTREAL_TO_OREGON' || params.SITE == 'OREGON_TO_MONTREAL' 
                }
                expression {
                    params.ACTION == 'FAILOVER'
                }
            }

            steps {
                script {
                    if (params.SITE == 'MONTREAL_TO_OREGON') {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                        
                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"
                        
                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/FailoverGalera.yml",
                            inventory: "${MONTREAL_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${MONTREAL_VAULT_PASSWORD_FILE_PATH}" 
                        )

                    } else {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                        
                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/FailoverGalera.yml",
                            inventory: "${OREGON_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${OREGON_VAULT_PASSWORD_FILE_PATH}",   
                        )
                    }   
                }
            }
        }

        // PIPELINE ACTION - FAILOVER FORCED
        stage('FAILOVER FORCED') {
            when {
                expression {
                    params.SITE == 'MONTREAL_TO_OREGON' || params.SITE == 'OREGON_TO_MONTREAL' 
                }
                expression {
                    params.ACTION == 'FAILOVER_FORCED'
                }
            }
            
            steps {
                script {
                    if (params.SITE == 'MONTREAL_TO_OREGON') {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                        
                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"

                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/FailoverGaleraForced.yml",
                            inventory: "${MONTREAL_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${MONTREAL_VAULT_PASSWORD_FILE_PATH}" 
                        )

                    } else {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"
                        
                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/FailoverGaleraForced.yml",
                            inventory: "${OREGON_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${OREGON_VAULT_PASSWORD_FILE_PATH}",   
                        )
                        
                    }
                }
            }
        }

        // PIPELINE ACTION
        stage('FAILBACK') {
            when {
                expression {
                    params.SITE == 'MONTREAL_TO_OREGON' || params.SITE == 'OREGON_TO_MONTREAL' 
                }
                expression {
                    params.ACTION == 'FAILBACK'
                }
            }
            
            steps{
                script {
                    if (params.SITE == 'MONTREAL_TO_OREGON') {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"

                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"
                        
                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/FailbackGalera.yml",
                            inventory: "${MONTREAL_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${MONTREAL_VAULT_PASSWORD_FILE_PATH}",   
                        )

                    } else {
                        sh "echo 'SITE SELECTED: ${params.SITE}'"
                        sh "echo 'ACTION SELECTED: ${params.ACTION}'"

                        // ENVIRONMENT VARIABLES - OREGON
                        sh "export ANSIBLE_HOST_KEY_CHECKING=${ANSIBLE_HOST_KEY_CHECKING}"
                        sh "export CLUSTER_ID=${CLUSTER_ID_OREGON}"
                                                
                        // ENVIRONMENT VARIABLES - MONTREAL
                        sh "export CLUSTER_ID=${CLUSTER_ID_MONTREAL}"

                        ansiblePlaybook(
                            playbook: "./geo-redundancy/Galera_ENABLERS_and_DR_SWITCH/AnsibleScripts/playbooks/FailbackGalera.yml",
                            inventory: "${OREGON_INVENTORY}",
                            vaultCredentialsId: "${ANSIBLE_VAULT_SECRET}",
                            colorized: true,
                            become: true,
                            extras: "-b --vault-password-file=${OREGON_VAULT_PASSWORD_FILE_PATH}",   
                        )
                    
                    }
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
