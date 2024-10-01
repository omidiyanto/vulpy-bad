pipeline {
    agent any
    parameters {
        choice(name: 'BUILD_TYPE', choices: ['Scan Only', 'Scan + Deploy'], description: 'Choose build type')
    }
   
    stages {
        stage('SAST Scan') {
            when {
                expression {
                    params.BUILD_TYPE == 'Scan Only'
                }
            }
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
    }
}
  
