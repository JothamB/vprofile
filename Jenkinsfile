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
        stage('deploy image in kubernetes')
        {
            steps
            {
                sh 'echo sudo kubectl set image deployment/app-deployment app=192.168.56.4:5000/vprofile-tomcat-kubernetes:$BUILD_NUMBER > kubectl-set-image'
                script
                {
                    def remote = [:]
                    remote.name = 'master01'
                    remote.host = '192.168.56.6'
                    remote.user = 'vagrant'
                    remote.identityFile = '/var/lib/jenkins/.ssh/id_rsa'
                    remote.allowAnyHosts = true
                    sshPut remote: remote, from: 'kubectl-set-image', into: '.'
                    sshCommand remote: remote, command: 'chmod 744 kubectl-set-image'
                    sshCommand remote: remote, command: './kubectl-set-image'
                }
            }
        }
    }
}
