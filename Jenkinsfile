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
                sh 'docker run --rm -v $(pwd):/app -w /app composer:latest composer install --no-interaction'
            }
        }

        stage('Copy .env') {
            steps {
                echo 'Setting up environment...'
                sh '''
                    if [ ! -f .env ]; then
                        cp .env.example .env
                    fi
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying with Docker Compose...'
                sh 'docker compose down || true'
                sh 'docker compose up -d --build'
            }
        }

        stage('Run Migrations') {
            steps {
                echo 'Running migrations...'
                sh 'sleep 10'
                sh 'docker compose exec -T app php artisan migrate --force'
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
