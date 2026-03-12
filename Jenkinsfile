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
                dir('src') {
                    sh 'php -r "copy(\'https://getcomposer.org/installer\', \'composer-setup.php\');"'
                    sh 'php composer-setup.php'
                    sh 'php composer.phar install --no-interaction'
                }
            }
        }
        stage('Copy .env') {
            steps {
                echo 'Setting up environment...'
                dir('src') {
                    sh '''
                        if [ ! -f .env ]; then
                            cp .env.example .env
                        fi
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying with Docker Compose...'
                sh 'docker compose down || true'
                sh 'docker compose up -d --build'
                sh 'chmod -R 777 src/storage'
            }
        }
        stage('Run Migrations') {
            steps {
                echo 'Running migrations...'
                sh 'sleep 15'
                sh 'docker compose exec -T app1 php artisan key:generate --force'
                sh 'docker compose exec -T app1 php artisan migrate --force'
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
