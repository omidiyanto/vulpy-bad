pipeline {
    agent any
    parameters {
        choice(name: 'BUILD_TYPE', choices: ['Scan Only', 'Scan + Deploy'], description: 'Choose build type', defaultValue: 'Scan + Deploy')
    }
    environment {
        APP_NAME = "sastdemo"
        DEPLOY_HOST_ENV = credentials('dev-env-host')
        DEPLOY_HOST_ENV_PASS = credentials('dev-env-host-pass')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        DOCKERHUB_USERNAME = "omidiyanto"
    }
   
    stages {
        stage('Test - SAST Scan') {
            steps {
                withSonarQubeEnv('sonarqube-omi') {
                    sh '''\
                    sonar-scanner \
                    -Dsonar.organization=demo-sast-omi \
                    -Dsonar.projectKey=demo-proj-omi \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=https://sonarcloud.io
                    '''
                }
            }
        }

        stage('Check Quality Gate') {
            when {
                expression {
                    return params.BUILD_TYPE == 'Scan + Deploy'
                }
            }
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to Quality Gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Build') {
            when {
                allOf {
                    expression {
                        params.BUILD_TYPE == 'Scan + Deploy'
                    }
                    expression {
                        currentBuild.result == null || currentBuild.result == 'SUCCESS'
                    }
                }
            }
            steps {
                sh '''\
                docker build -t ${APP_NAME}:latest .
                '''
            }
        }
        
        stage('Release') {
            when {
                allOf {
                    expression {
                        params.BUILD_TYPE == 'Scan + Deploy'
                    }
                    expression {
                        currentBuild.result == null || currentBuild.result == 'SUCCESS'
                    }
                }
            }
            steps {
                sh '''\
                docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}
                docker tag ${APP_NAME}:latest docker.io/${DOCKERHUB_USERNAME}/${APP_NAME}:latest
                docker push docker.io/${DOCKERHUB_USERNAME}/${APP_NAME}:latest
                '''
            }
        }

        stage('Deploy') {
            when {
                allOf {
                    expression {
                        params.BUILD_TYPE == 'Scan + Deploy'
                    }
                    expression {
                        currentBuild.result == null || currentBuild.result == 'SUCCESS'
                    }
                }
            }
            steps {
                sh '''\
                sshpass -p ${DEPLOY_HOST_ENV_PASS} ssh root@${DEPLOY_HOST_ENV} "docker pull docker.io/${DOCKERHUB_USERNAME}/${APP_NAME}:latest"
                sshpass -p ${DEPLOY_HOST_ENV_PASS} ssh root@${DEPLOY_HOST_ENV} "docker rm -f ${APP_NAME}"
                sshpass -p ${DEPLOY_HOST_ENV_PASS} ssh root@${DEPLOY_HOST_ENV} "docker run -d --name ${APP_NAME} -p 5000:5000 docker.io/${DOCKERHUB_USERNAME}/${APP_NAME}:latest"
                '''
            }
        }
    }
}
