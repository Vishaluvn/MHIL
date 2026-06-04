pipeline {
    agent any

    stages {

        stage('Restore') {
            steps {
                bat 'dotnet restore mhil-net.sln'
            }
        }

        stage('Build') {
            steps {
                bat 'dotnet build mhil-net.sln --configuration Release'
            }
        }

        stage('Publish') {
            steps {
                bat 'dotnet publish mhil-net.csproj --configuration Release -o publish'
            }
        }

        stage('Deploy') {
            steps {
                bat 'robocopy publish D:\\inetpub\\wwwroot\\MHIL /MIR'
            }
        }

    }
}
