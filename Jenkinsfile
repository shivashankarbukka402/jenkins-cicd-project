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
        SONAR_HOST_URL='http://13.127.205.0:9000'
    }

         stages {
        stage('CHECKOUT') {
            steps{
                script {
                    git branch: "${env.GIT_BRANCH}",
                     credentialsId: "${env.GIT_CREDENTIALS}",
                      url: "${env.GIT_URL}"
                }
            }
        }
        stage('Sonar Code Quality check') {
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
                    sh '''
                        ls -lrt
                    '''
                    dir('./backend') {
                        dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}", "-f ${DOCKERFILE_BASE} .")
                        docker.withRegistry('', "${DOCKER_REGISTRY_CRED_ID}") { 
                            dockerImage.push() 
                        }
                    }
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    trivy image \
                    --severity HIGH,CRITICAL \
                    --format template \
                    --template '@/home/ubuntu/trivy/trivy_html.tpl' \
                    --output 'trivy_backend.html' ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }
}    


