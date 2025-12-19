pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'pipeline {
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
                sh '''
                chmod +x build.sh
                ./build.sh
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Application built and deployed on same server"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
'
            }
        }

        stage('Build & Deploy (Same Server)') {
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
            echo "✅ Application built and deployed on same server"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
