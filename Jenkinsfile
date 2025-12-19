pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Rajesh-210/success-project.git'
            }
        }

        stage('Build & Deploy') {
            steps {
                sh '''
                chmod +x build.sh
                ./build.sh
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}
