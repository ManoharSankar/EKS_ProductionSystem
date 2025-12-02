pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        AWS_CREDS  = credentials('aws-jenkins-creds')
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
                    export AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}
                    export AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}
                    export AWS_DEFAULT_REGION=${AWS_REGION}

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
