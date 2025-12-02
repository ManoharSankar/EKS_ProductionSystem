pipeline {
    agent any

    environment {
        TF_VERSION = "1.9.5"
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform --version
                    terraform init -input=false
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan -out=tfplan -input=false
                '''
            }
        }

        stage('Approve Apply') {
            when {
                branch 'main'
            }
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Apply Terraform changes?"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    terraform apply -input=false -auto-approve tfplan
                '''
            }
        }

        stage('Terraform Output') {
            steps {
                sh '''
                    terraform output
                '''
            }
        }
    }

    post {
        success {
            echo "Terraform pipeline completed successfully!"
        }
        failure {
            echo "Terraform pipeline FAILED!"
        }
        always {
            cleanWs()
        }
    }
}
