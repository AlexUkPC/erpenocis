pipeline {
    agent {
        label 'ssh'  
    }
    parameters {
        string(name: 'REF', defaultValue: '\${ghprbActualCommit}', description: 'Commit to build')
    }
    stages {
        stage('Prepare x files') {
            steps {
                sh 'chmod +x get-next-version.sh'
                sh 'chmod +x integration-test.sh'
                sh 'chmod +x package.sh'
                sh 'chmod +x erpenocis/docker-entrypoint.sh'
                sh 'chmod +x erpenocis/bin/rails'
                sh 'chmod +x erpenocis/bin/rake'
                sh 'chmod +x erpenocis/bin/setup'
                sh 'chmod +x erpenocis/bin/spring'
                sh 'chmod +x erpenocis/bin/webpack'
                sh 'chmod +x erpenocis/bin/webpack-dev-server'
                sh 'chmod +x erpenocis/bin/yarn'
            }
        }
        stage('Bundle Install') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml run --rm web_erpenocis_jenkins bundle install'
            }
        }
        stage('Webpacker Install') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml run --rm web_erpenocis_jenkins bin/rails webpacker:install'
            }
        }
        stage('Stop old containers') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml stop'
            }
        }
        stage('Start server') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml up -d --remove-orphans --force-recreate'
            }
        }
        stage('Create database') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml exec -T --user "$(id -u):$(id -g)" web_erpenocis_jenkins bin/rails db:drop'
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml exec -T --user "$(id -u):$(id -g)" web_erpenocis_jenkins bin/rails db:create'
            }
        }
        stage('Migrate database') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml exec -T --user "$(id -u):$(id -g)" web_erpenocis_jenkins bin/rails db:migrate'
            }
        }
        stage('Wait for server to start') {
            steps {
                timeout(10) {
                    waitUntil {
                        script {
                            try {
                                def response = httpRequest 'http://0.0.0.0:13028'
                                return (response.status == 200)
                            }
                            catch (exception) {
                                return false
                            }
                        }
                    }
                }
            }
        }
        stage('Unit test') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml exec -T --user "$(id -u):$(id -g)" web_erpenocis_jenkins bundle exec rspec spec/models'
            }   
        } 
        stage('End-to-end test') {
            steps {
                sh '/usr/local/bin/docker-compose -f docker-compose-jenkins.yml exec -T web_erpenocis_jenkins bundle exec rspec spec/system'
            }   
        } 
    }
}