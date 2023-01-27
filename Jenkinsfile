pipeline {
    agent any

    environment {
        TAG_NAME = sh(returnStdout: true, script: "git describe --tags").trim()
    }
    stages {
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        stage('Build') {
            when {
                buildingTag()
                beforeAgent true
            }
            steps {
                sh 'make docker'
            }
        }
        stage('Publish') {
            when {
                buildingTag()
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