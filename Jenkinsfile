pipeline {
    agent any
   
    stages {
        stage('Scan') {
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
  
