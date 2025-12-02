pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        AWS_CREDS  = credentials('AWS_Credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ManoharSankar/EKS_ProductionSystem.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan -out plan.out
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform apply -auto-approve plan.out
                '''
            }
        }
    }
}
