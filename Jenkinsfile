pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "tinuns/my-web-app"
        DOCKER_CREDENTIALS = "dockerhub"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/tinu-ns/jenkins-dockerhub-deploy.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE:latest .'
                }
            }
        }
	
	stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                }
            }
        }

	stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }

	stage('Deploy to AWS EC2') {
            steps {
               script {
            	sshagent(['ec2-ssh-key-id']) {
                	sh """
                	ssh -o StrictHostKeyChecking=no ec2-user@3.107.27.207 <<EOF
                	docker pull $DOCKER_IMAGE:latest
                	docker ps -q -f name=my-web-app && docker stop my-web-app || true
                	docker ps -a -q -f name=my-web-app && docker rm my-web-app || true
                	docker run -d --name my-web-app -p 8081:80 $DOCKER_IMAGE:latest
                	EOF
                	"""

                    }
                }
            }
       }
   }
}
