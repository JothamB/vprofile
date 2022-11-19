pipeline
{
    agent any
    tools
    {
        jdk 'jdk8'
        maven 'maven3'
    }
    stages
    {
        stage('fetch')
        {
            steps
            {
                git branch: 'kubernetes', url: 'https://github.com/jothamb/vprofile'
            }
        }
        stage('build')
        {
            steps
            {
                sh 'mvn clean install'
            }
        }
        stage('create image')
        {
            steps
            {
                sh 'docker build -t vprofile-tomcat-kubernetes:$BUILD_NUMBER .'
            }
        }
        stage('push image to registry')
        {
            steps
            {
                sh 'docker tag vprofile-tomcat-kubernetes:$BUILD_NUMBER 192.168.56.4:5000/vprofile-tomcat-kubernetes:$BUILD_NUMBER'
                sh 'docker push 192.168.56.4:5000/vprofile-tomcat-kubernetes:$BUILD_NUMBER'
                sh 'docker rmi 192.168.56.4:5000/vprofile-tomcat-kubernetes:$BUILD_NUMBER'
            }
        }
    }
}
