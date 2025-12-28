pipeline {
    agent any

    environment {
        DOCKER_HUB = "nasir1999"
        APP_NAME   = "food-delivery-app"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build') {
            steps {
                sh '''
                echo "Node version:"
                /usr/bin/node -v

                echo "NPM version:"
                /usr/bin/npm -v

                echo "Installing dependencies..."
                /usr/bin/npm install

                echo "Building Angular app..."
                /usr/bin/npm run build
                '''
            }
        }

        stage('Docker Build & Push') {
            environment {
                DOCKER_USER = credentials('DOCKER_USER')
                DOCKER_PASS = credentials('DOCKER_PASS')
            }
            steps {
                sh '''
                echo "Building Docker image..."
                docker build -t ${DOCKER_HUB}/${APP_NAME}:latest .

                echo "Logging in to Docker Hub..."
                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                echo "Pushing Docker image..."
                docker push ${DOCKER_HUB}/${APP_NAME}:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                echo "Stopping old container (if exists)..."
                docker stop ${APP_NAME} || true
                docker rm ${APP_NAME} || true

                echo "Starting new container..."
                docker run -d \
                  --name ${APP_NAME} \
                  -p 80:80 \
                  ${DOCKER_HUB}/${APP_NAME}:latest
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Frontend deployed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs above."
        }
    }
}
