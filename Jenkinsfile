pipeline {
    agent any

    environment {
        TAG_NAME = sh(returnStdout: true, script: "git describe --always --dirty --tags").trim()
    }
    stages {
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        stage('Build') {
            when {
                tag comparator: 'REGEXP', pattern: '\\d+.\\d+.\\d+'
                beforeAgent true
            }
            steps {
                sh 'make docker'
            }
        }
        stage('Publish') {
            when {
                tag comparator: 'REGEXP', pattern: '\\d+.\\d+.\\d+'
                beforeAgent true
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