pipeline {
    agent any

    environment {
        DOCKER_HUB = "nasir1999"
        APP_NAME   = "food-delivery-app"
    }

    stages {

        stage('Install & Build') {
            steps {
                sh '''
                /usr/bin/node -v
                /usr/bin/npm -v
                /usr/bin/npm install
                /usr/bin/npm run build
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh '''
                docker build -t ${DOCKER_HUB}/${APP_NAME}:latest .
                docker login -u $DOCKER_USER -p $DOCKER_PASS
                docker push ${DOCKER_HUB}/${APP_NAME}:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                docker stop ${APP_NAME} || true
                docker rm ${APP_NAME} || true
                docker run -d --name ${APP_NAME} -p 80:80 ${DOCKER_HUB}/${APP_NAME}:latest
                '''
            }
        }
    }
}
