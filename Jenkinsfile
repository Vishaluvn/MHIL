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

         stage('Clean') {
    steps {
        bat 'if exist publish rmdir /s /q publish'
    }
}

        stage('Publish') {
            steps {
                bat 'dotnet publish mhil-net.csproj --configuration Release -o publish'
            }
        }

        stage('Backup') {
            steps {
                bat '''
                if not exist D:\\Backup\\MHIL_Backup mkdir D:\\Backup\\MHIL_Backup

                robocopy D:\\inetpub\\wwwroot\\MHIL D:\\Backup\\MHIL_Backup /MIR

                IF %ERRORLEVEL% LEQ 7 (
                    EXIT /B 0
                )

                EXIT /B %ERRORLEVEL%
                '''
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

    stage('Health Check') {
    steps {
        bat 'curl http://localhost/MHIL'
    }
}
        post {
        failure {
            bat '''
            echo Deployment failed. Starting rollback...

            iisreset /stop

            robocopy D:\\Backup\\MHIL_Backup D:\\inetpub\\wwwroot\\MHIL /MIR

            iisreset /start
            '''
        }
    }
}
