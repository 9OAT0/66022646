pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'jenkins-app' // ชื่อ Docker image
        PORT = '3584' // Port ที่จะใช้ในการเข้าถึง
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
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Docker Run') {
            steps {
                script {
                    sh "docker run -d -p ${PORT}:3000 ${DOCKER_IMAGE}"
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
