// Define a Docker image that includes Terraform
def TERRAFORM_IMAGE = 'hashicorp/terraform:latest'

pipeline {
    agent {
        docker {
            image TERRAFORM_IMAGE
            args '-u root'
        }
    }

    // Set environment variables used by the 'variables.tf' defaults
    environment {
        // Assume 'AWS_CREDENTIALS' is a Jenkins Secret Text credential 
        // storing AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
        TF_VAR_aws_region = 'ap-south-1' 
        TF_VAR_kubernetes_version = '1.30' // Passed directly to main.tf
    }

    stages {
        stage('Initialize Terraform') {
            steps {
                // Authenticate and initialize
                withCredentials([aws(credentialsId: 'AWS_Credentials', variablePrefix: 'AWS_')]) {
                    sh 'terraform init -upgrade'
                }
            }
        }

        stage('Validate & Format') {
            steps {
                sh 'terraform fmt -check'
                sh 'terraform validate'
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                // Create execution plan
                withCredentials([aws(credentialsId: 'AWS_Credentials', variablePrefix: 'AWS_')]) {
                    sh 'terraform plan -out=tfplan -lock=true'
                }
                
                archiveArtifacts artifacts: 'tfplan', fingerprint: true
            }
        }

        stage('Manual Approval for Apply') {
            steps {
                script {
                    // Extract changes summary for better review
                    def plan_summary = sh(
                        script: 'terraform show -json tfplan | jq -r \'[.resource_changes[] | select(.change.actions!=["no-op"]) | {type:.type, actions:.change.actions}]\'',
                        returnStdout: true,
                        returnStatus: true
                    ).trim()

                    input {
                        message 'Proceed with Terraform Apply? Review the plan summary below.'
                        ok 'Deploy Infrastructure'
                        parameters {
                            string(name: 'PLAN_SUMMARY', defaultValue: plan_summary, description: 'Summary of proposed changes.')
                        }
                    }
                }
            }
        }

        stage('Apply Terraform Changes') {
            steps {
                // Apply the previously generated plan file
                withCredentials([aws(credentialsId: 'AWS_Credentials', variablePrefix: 'AWS_')]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
    
    post {
        always {
            // Clean up temporary files regardless of build success
            sh 'rm -rf .terraform/ .terraform.lock.hcl tfplan'
        }
    }
}