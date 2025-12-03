pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Choose Terraform action'
        )
    }

    stages {

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Terraform Init") {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh """
                        terraform init -input=false
                    """
                }
            }
        }

        stage("Terraform Plan") {
            when {
                expression { params.ACTION == "plan" || params.ACTION == "apply" }
            }
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh """
                        terraform plan -out=tfplan
                    """
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: 'tfplan', fingerprint: true
                }
            }
        }

        stage("Approval Required") {
            when {
                anyOf {
                    expression { params.ACTION == 'apply' }
                    expression { params.ACTION == 'destroy' }
                }
            }
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    input message: "Approve to proceed with ${params.ACTION}?"
                }
            }
        }

        stage("Terraform Apply") {
            when {
                expression { params.ACTION == "apply" }
            }
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh """
                        terraform apply -auto-approve tfplan
                    """
                }
            }
        }

        stage("Terraform Destroy") {
            when {
                expression { params.ACTION == "destroy" }
            }
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-credentials',
                     accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                ]) {
                    sh """
                        terraform destroy -auto-approve
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully."
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
