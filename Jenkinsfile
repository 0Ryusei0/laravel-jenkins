pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Pulling latest code from GitHub...'
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                sh 'docker run --rm -v ${WORKSPACE}/src:/app -w /app composer:latest composer install --no-interaction'
            }
        }

        stage('Copy .env') {
            steps {
                echo 'Setting up environment...'
                sh '''
                    if [ ! -f ${WORKSPACE}/src/.env ]; then
                        cp ${WORKSPACE}/src/.env.example ${WORKSPACE}/src/.env
                    fi
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying with Docker Compose...'
                sh 'docker compose -f ${WORKSPACE}/docker-compose.yml down || true'
                sh 'docker compose -f ${WORKSPACE}/docker-compose.yml up -d --build'
            }
        }

        stage('Run Migrations') {
            steps {
                echo 'Running migrations...'
                sh 'sleep 10'
                sh 'docker compose -f ${WORKSPACE}/docker-compose.yml exec -T app php artisan migrate --force'
            }
        }
    }

    post {
        success {
            echo 'Deploy berhasil!'
        }
        failure {
            echo 'Deploy gagal!'
        }
    }
}
