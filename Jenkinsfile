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
                tag 'test-tag'
            }
            steps {
                sh 'make docker'
            }
        }
        stage('Publish') {
            when {
                tag 'test-tag'
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