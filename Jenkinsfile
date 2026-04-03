pipeline {
    agent {
        label 'Jenkins-agent'
    }
    tools {
        jdk 'java17'
        maven 'Maven3'
    }
    environment {
        APP_NAME          = "register-app-pipeline"
        RELEASE           = "1.0.0"
        DOCKER_USER       = "cyruss07"
        DOCKER_PASS       = 'dockerhub'
        IMAGE_NAME        = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG         = "${RELEASE}-${BUILD_NUMBER}"
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
                    // credentialsId here refers to the SonarQube server config in Jenkins
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    // ✅ FIX: credentialsId is NOT a valid param for waitForQualityGate
                    // The token is already handled by withSonarQubeEnv above
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    // ✅ FIX 1: Use the correct Docker Hub registry URL
                    // ✅ FIX 2: Merged into ONE withRegistry block (no need for two)
                    // ✅ FIX 3: Added IMAGE_TAG to docker.build so the image is properly tagged
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_PASS) {
                        def docker_image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }

        stage("Trigger CD Pipeline") {
            steps {
                script {
                    // ✅ FIX: JENKINS_API_TOKEN was declared but never used — added CD trigger
                    sh """
                        curl -v -k --user admin:${JENKINS_API_TOKEN} \
                        -X POST -H 'cache-control: no-cache' \
                        -H 'content-type: application/x-www-form-urlencoded' \
                        --data 'IMAGE_TAG=${IMAGE_TAG}' \
                        'http://<JENKINS_URL>/job/<CD-JOB-NAME>/buildWithParameters?token=gitops-token'
                    """
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
