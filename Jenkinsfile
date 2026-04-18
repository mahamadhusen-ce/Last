pipeline {
    agent {
        label 'Jenkins-agent'
    }

    tools {
        jdk 'java17'
        maven 'Maven3'
    }

    environment {
        APP_NAME = "register-app-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "cyruss07"
        DOCKER_CREDENTIALS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
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

        stage("SonarQube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                    }
                }
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        docker_image = docker.build("${IMAGE_NAME}")
                    }
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }

        // ✅ FIXED CD TRIGGER STAGE
        stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh """
                    curl -v -k --user LAST-X:${JENKINS_API_TOKEN} \
                    -X POST \
                    -H 'cache-control: no-cache' \
                    -H 'content-type: application/x-www-form-urlencoded' \
                    --data 'IMAGE_TAG=${IMAGE_TAG}' \
                    "http://18.184.238.79:8080/job/gitops-register-app-cd/buildWithParameters?token=gitops-token"
                    """
                }
            }
        }

        stage("Trivy Security Scan") {
            steps {
                sh """
                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                aquasec/trivy:0.48.3 image ${IMAGE_NAME}:${IMAGE_TAG} \
                --no-progress --severity HIGH,CRITICAL --format table
                """
            }
        }

        stage("Cleanup Artifacts") {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
                }
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
