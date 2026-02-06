pipeline {
    agent {
        label 'Jenkins-Agent'
    }

    tools {
        jdk 'java17'
        maven 'Maven3'
    }

    stages {

        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout from SCM") {
            steps {
                git branch: 'main',
                    credentialsId: 'github',
                    url: 'https://github.com/mahamadhusen-ce/Last'
            }
        }

        stage("Build Application") {
            steps {
                sh "mvn clean package"
            }
        }

        stage("Test Application") {
            steps {
                sh "mvn test"
            }
        }
    }

    post {
        success {
            echo "✅ Build and Tests completed successfully!"
        }
        failure {
            echo "❌ Build or Tests failed. Please check logs."
        }
    }
}
