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
                tag '**/*-*-*'
            }
            steps {
                sh 'make docker'
            }
        }
        stage('Publish') {
            when {
                tag '**/*-*-*'
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