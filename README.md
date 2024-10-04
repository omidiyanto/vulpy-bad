<p align="center">
  <a href="https://sonarcloud.io/summary/new_code?id=demo-proj-omi">
    <img src="https://sonarcloud.io/api/project_badges/measure?project=demo-proj-omi&metric=alert_status" alt="Quality Gate Status" />
  </a>
  <br>
  <a href="https://sonarcloud.io/summary/new_code?id=demo-proj-omi">
    <img src="https://sonarcloud.io/images/project_badges/sonarcloud-white.svg" alt="SonarCloud" />
  </a>
</p>

<h1 align="center"> DevSecOps - Simple SAST Scan </h1>
<p align="center"> This code is based on this repository: <a href="https://github.com/fportantier/vulpy.git">https://github.com/fportantier/vulpy.git</a></p>

## Overview
This project serves as a straightforward example of a CI/CD pipeline designed with DevSecOps principles. The primary objective of this pipeline is to automate the entire workflow of application development, from code writing to deployment, ensuring a secure and efficient process.

## Workflow Overview
<img align="center" src="https://raw.githubusercontent.com/omidiyanto/vulpy-bad/refs/heads/master/IMAGES/Workflow%20Overview.png"></img>
<br>

### Tools Used
- GitHub ---> Source Code Management (Repository)
- Jenkins ---> Running CI/CD Pipeline
- Docker ---> Build the application
- Dockerhub ---> Stores the built application oh the registry
- Elastic Cloud Compute (ECS) --> Deploy the application on testing environment with ECS on Alibaba Cloud

### Descriptions
1. This project features two build parameters in the pipeline: 'Scan Only' and 'Scan + Deploy'.
2. Developers can choose the build type manually in Jenkins or automatically trigger the pipeline upon pushing a commit to the repository. The default build type for automatic triggers is 'Scan Only'. To deploy the application, the pipeline must be triggered manually in Jenkins by selecting 'Scan + Deploy'.
3. When selecting 'Scan Only', Jenkins will initiate the pipeline to check out the repository and run SAST analysis, with the results stored in SonarCloud. This build type will not proceed further and will only perform the scan and analysis of the code.
4. For 'Scan + Deploy', the pipeline must be run manually in Jenkins by selecting the build type parameter 'Scan + Deploy'. First, Jenkins will check out the repository and perform SAST analysis. If the SAST analysis passes, the pipeline will continue to build the application into a container image using Docker. Once the image is built, the artifact will be released and stored in the DockerHub registry. The final stage involves deploying the stored container image to an ECS instance on Alibaba Cloud for the Development and Testing environment, making the application accessible to users.

## Steps
1. Install Jenkins on ubuntu server, following the official documentation https://pkg.jenkins.io/debian-stable/
2. login on jenkins dashboard
3. Go to "Manage Jenkins", then select "Plugins"
4. First, install the required plugins, which is <b>GitHub Integration Plugin</b> and <b>SonarQube Scanner for Jenkins</b>. If required, restart the jenkins service.
5. Sign Up on Sonarcloud (https://sonarcloud.io/)
6. Create New Organization, then create new project.
7. On Analysis Method, choose "Manually", then choose option <b>Other (for JS, TS, Go, Python, PHP, ...)</b>
8. Follow the steps to download and install "SonarScanner" on the jenkins linux server.
9. You'll be given SonarScanner command to executed to the projects, Keep this command for now. For example it should look like this:
'''
sonar-scanner \
  -Dsonar.organization=demo-sast-omi \
  -Dsonar.projectKey=demo-proj-omi \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io
'''