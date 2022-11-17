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
                git 'https://github.com/jothamb/vprofile'
            }
        }
        stage('build')
        {
            steps
            {
                sh 'mvn clean install'
            }
        }
        stage('deploy')
        {
            steps
            {
                script
                {
                    def remote = [:]
                    remote.name = 'app01'
                    remote.host = '192.168.56.4'
                    remote.user = 'vagrant'
                    remote.identityFile = '/var/lib/jenkins/.ssh/id_rsa'
                    remote.allowAnyHosts = true
                    sshCommand remote: remote, command: 'sudo systemctl stop tomcat9.service'
                    sshCommand remote: remote, command: 'sudo rm -rf /var/lib/tomcat9/webapps/*'
                    sshPut remote: remote, from: './target', filterRegex: /.war$/, into: '.'
                    sshCommand remote: remote, command: 'sudo mv ~/target/*.war /var/lib/tomcat9/webapps/ROOT.war'
                    sshCommand remote: remote, command: 'rm -r ./target'
                    sshCommand remote: remote, command: 'sudo chown tomcat.tomcat /var/lib/tomcat9/webapps/ROOT.war'
                    sshCommand remote: remote, command: 'sudo systemctl start tomcat9.service'
                }
            }
        }
    }
}
