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

        stage('Clean') {
    steps {
        bat 'if exist publish rmdir /s /q publish'
    }
}

        stage('Deploy') {
            steps {
                bat '''
                iisreset /stop

                robocopy publish D:\\inetpub\\wwwroot\\MHIL /MIR

                IF %ERRORLEVEL% LEQ 7 (
                    iisreset /start
                    EXIT /B 0
                )

                EXIT /B %ERRORLEVEL%
                '''
            }
        }
    }
}
