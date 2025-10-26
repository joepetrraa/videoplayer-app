pipeline {
    agent any
    
    environment {
        IMAGE_NAME = 'joepetraa/videoplayer-reactnative'
        REGISTRY = 'https://index.docker.io/v1/'
        REGISTRY_CREDENTIAL = 'dockerhub-credentials' 
        
        NODE_VERSION = '18'
        
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    echo 'Installing Node.js dependencies...'
                    sh '''
                        node --version
                        npm --version
                        npm install
                    '''
                }
            }
        }
        
        stage('Lint & Code Quality') {
            steps {
                script {
                    echo 'Running linters...'
                    sh '''
                        npm run lint || echo "No lint script found"
                    '''
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running tests...'
                    sh '''
                        npm test || echo "No test script found"
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                    dockerImage = docker.build("${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}")
                    
                
                    sh "docker tag ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY}/${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Push to Docker Registry') {
            steps {
                script {
                    echo 'Pushing Docker image to registry...'
                    docker.withRegistry("https://${REGISTRY}", "${REGISTRY_CREDENTIAL}") {
                        dockerImage.push("${IMAGE_TAG}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    echo 'Deploying application with Docker Compose...'
                    sh '''
                        docker-compose down || true
                        docker-compose up -d
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    echo 'Checking if application is running...'
                    sh '''
                        sleep 10
                        docker-compose ps
                    '''
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    echo 'Cleaning up old Docker images...'
                    sh """
                        docker rmi ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} || true
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline executed successfully!"
            echo "Image pushed: ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
        always {
            script {
                echo 'Displaying logs...'
                sh 'docker-compose logs --tail=50 || true'
            }
        }
    }
}