pipeline {
    // 1. Define the agent
    // Use 'agent any' to run on any available node, 
    // or use a specific label if you have dedicated build nodes:
    // agent { label 'my-terraform-agent' } 
    agent any

    // 2. Environment Setup
    environment {
        // Assume 'AWS_CREDENTIALS' is a Jenkins Secret Text credential storing 
        // AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
        TF_VAR_aws_region         = 'ap-south-1' 
        TF_VAR_kubernetes_version = '1.30' // Passed directly to main.tf
    }

    stages {
        stage('Initialize Terraform') {
            steps {
                // The withCredentials block injects AWS environment variables 
                // into the shell session for authentication.
                withCredentials([aws(credentialsId: 'AWS_Credentials', variablePrefix: 'AWS_')]) {
                    sh 'terraform init -upgrade'
                }
            }
        }

        stage('Validate & Format') {
            steps {
                // These commands rely on the 'terraform' binary being in the PATH of the agent.
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
                
                // Archive the plan file for verification
                archiveArtifacts artifacts: 'tfplan', fingerprint: true
            }
        }

        stage('Manual Approval for Apply') {
            steps {
                script {
                    // Extract changes summary for better review (requires 'jq' on the agent)
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
            // Clean up temporary files
            sh 'rm -rf .terraform/ .terraform.lock.hcl tfplan'
        }
    }
}