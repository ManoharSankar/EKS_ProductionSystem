pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        TF_IN_AUTOMATION = "true"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ManoharSankar/EKS_ProductionSystem.git'
            }
        }

        stage('Configure AWS Credentials') {
            steps {
                withCredentials([ [$class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'AWS_Credentials'] ]) {
                        sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            sh 'rm -f tfplan'
        }
    }
}
