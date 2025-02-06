pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'jenkins-app'
        PORT = '<3584>' // เปลี่ยนเป็น port ที่คุณเลือก
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/9OAT0/66022646.git', branch: 'main'
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'npm run build'
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${66022646} ."
                }
            }
        }
        stage('Docker Run') {
            steps {
                script {
                    sh "docker run -d -p ${PORT}:3584 ${66022646}"
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
