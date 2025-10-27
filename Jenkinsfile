pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/shivashankarbukka402/jenkins-cicd-project.git'
        GIT_BRANCH = 'main'
        GIT_CREDENTIALS = 'github_token'
        IMAGE_NAME = 'shiva9828/backhand'
        IMAGE_TAG = 'latest'
        DOCKERFILE_BASE = 'Dockerfile'
        DOCKER_REGISTRY_CRED_ID = 'docker_token'
        SONAR_HOST_URL = 'http://13.233.168.238:9000'
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    git branch: "${env.GIT_BRANCH}",
                        credentialsId: "${env.GIT_CREDENTIALS}",
                        url: "${env.GIT_URL}"
                }
            }
        }

        stage('Sonar Code Quality Check') {
            steps {
                script {
                    dir('./backend') {
                        withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                            sh """
                                sonar-scanner \
                                  -Dsonar.projectKey=backend \
                                  -Dsonar.sources=. \
                                  -Dsonar.host.url=${env.SONAR_HOST_URL} \
                                  -Dsonar.token=${SONAR_TOKEN}
                            """
                        }
                    }
                }
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    dir('./backend') {
                        echo "Building Docker Image..."
                        def dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}", "-f ${DOCKERFILE_BASE} .")

                        echo "Pushing Docker Image to DockerHub..."
                        docker.withRegistry('', "${DOCKER_REGISTRY_CRED_ID}") {
                            dockerImage.push()
                        }
                    }
                }
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                script {
                    echo "Running Trivy Scan..."
                    sh """
                        trivy image \
                        --severity HIGH,CRITICAL \
                        --format template \
                        --template '@/home/ubuntu/trivy/trivy_html.tpl' \
                        --output 'trivy_backend.html' ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Cleaning workspace..."
            cleanWs()
        }
    }
}
   


