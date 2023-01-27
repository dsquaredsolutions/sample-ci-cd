pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        stage('Build') {
            when {
                buildingTag()
            }
            steps {
                sh 'make docker'
            }
        }
        stage('Publish') {
            when {
                buildingTag()
            }
            environment {
                DOCKER_TOKEN = credentials('docker-token')
            }
            steps {
                sh 'make publish'
            }
        }
    }
}