pipeline {
    agent any
    environment{
        DOCKER_USERNAME=credentials('DOCKER_USERNAME')
        DOCKER_PASSWORD=credentials("DOCKER_PASSWORD")
        EC2_HOST=credentials("EC2_HOST")
        EC2_KEY=credentials("EC2_KEY")
    }
    stages{
        stage("checkout code"){
            steps{
                git branch: 'peter-branch', url: 'https://github.com/bigcephas1/React-ToDoList.git'
            }
        }
        stage('Build image and push'){
            steps{
                sh 'chmod 777 buildscript.sh'
                sh 'docker build -t $DOCKER_USERNAME/ci_backend_full_pipeline:v1 backend/Dockerfile'
                sh "docker build -t $DOCKER_USERNAME/ci_frontend_full_pipeline:v1 dive-react-app/Dockerfile"
                sh 'docker push $DOCKER_USERNAME/ci_backend_full_pipeline:v1'
                sh 'docker push $DOCKER_USERNAME/ci_frontend_full_pipeline:v1'
            }
        }
        // stage("Deploy to ec2"){
        //     steps{
        //         writeFile file: 'deployment_key.pem', text: 'EC2_KEY'
        //         sh 'chmod 600 deployment_key.pem'
        //         sh """
        //         ssh -o StrictHostKeyChecking=no -i 
        //         deployment_key.pem ubuntu@${EC2_HOST}'
        //         """
        //     }
        // }
    }
}
