pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Rajesh-210/success-project.git'
            }
        }

        stage('Build & Deploy (Same Server)') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: '7a0f39da-b347-427f-914a-35aa843e7c41',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                    chmod +x build.sh
                    ./build.sh
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
