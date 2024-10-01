pipeline {
    agent any
    parameters {
        choice(name: 'BUILD_TYPE', choices: ['Scan Only', 'Scan + Deploy'], description: 'Choose build type')
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
                echo 'Build'
                sh '''\
                docker build -t my_image:$(date +$D) .
                '''
            }
        }
    }
}
