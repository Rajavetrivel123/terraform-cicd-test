pipeline {
    agent any

    tools {
       terraform 'terraform'
    }

    parameters {
        choice(name: 'TF_VAR_environment', choices: ['dev', 'test', 'uat', 'prod'], description: 'Select Environment')
        choice(name: 'TERRAFORM_OPERATION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Operation')
    }

    environment {
        // TF_VAR_environment = params.TF_VAR_environment
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    options {
                timestamps ()
                ansiColor('xterm')
            }


    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // withCredentials([string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                    //                  string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    //     sh 'terraform init'
                    // }
                    sh 'terraform init'
                }
            }
        }

        stage('Select or Create Terraform Workspace') {
            steps {
                script {
                    def workspaceName = '${TF_VAR_environment}'
                    def workspaceExists = sh(script: 'terraform workspace list | grep -q "^' + workspaceName + '$"', returnStatus: true) == 0
                    if (!workspaceExists) {
                        try {
                            sh 'terraform workspace new ' + workspaceName
                        } catch (Exception e) {
                            // Ignore the error if workspace already exists
                            echo "Workspace ${workspaceName} already exists."
                        }
                    }
                    sh 'terraform workspace select ' + workspaceName
                }
            }
        }

        stage('Terraform Operation') {
            steps {
                script {
                    // Run Terraform based on the selected operation
                    switch(params.TERRAFORM_OPERATION) {
                        case 'plan':
                            sh "terraform plan -var-file='${TF_VAR_environment}.tfvars' -out=tfplan"
                            break
                        case 'apply':
                            sh "terraform plan -var-file='${TF_VAR_environment}.tfvars' -out=tfplan"
                            sh 'terraform apply -auto-approve tfplan'
                            break
                        case 'destroy':
                            sh "terraform destroy -var-file='${TF_VAR_environment}.tfvars' -auto-approve"
                            break
                        default:
                            error "Invalid Terraform operation selected"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up artifacts, e.g., the Terraform plan file
            deleteDir()
        }
    }
}
