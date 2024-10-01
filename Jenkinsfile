pipeline {
    agent any
    parameters {
        choice(name: 'BUILD_TYPE', choices: ['Scan Only', 'Scan + Deploy'], description: 'Choose build type')
    }
    environment {
        APP_NAME = "sast_demo"
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
    }
   
    stages {
        stage('Test - SAST Scan') {
            steps {
                withSonarQubeEnv('sonarqube-omi') {
                    sh '''\
                    echo appname = ${APP_NAME}
                    echo password = ${DOCKERHUB_PASSWORD}
                    '''
                }
            }
        }

        
        
    }
}
