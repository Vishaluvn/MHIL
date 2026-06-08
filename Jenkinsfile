pipeline {
    agent any

     environment {
        APP_PATH = 'D:\\inetpub\\wwwroot\\MHIL'
        BACKUP_PATH = 'D:\\Backup\\MHIL_Backup'
        APP_URL = 'http://localhost:7685'
    }

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
                if not exist "%BACKUP_PATH%" mkdir "%BACKUP_PATH%"

                robocopy "%APP_PATH%" "%BACKUP_PATH%" /MIR

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

        robocopy publish "%APP_PATH%" /MIR

        set RC=%ERRORLEVEL%

        iisreset /start

        IF %RC% LEQ 7 (
            EXIT /B 0
        )

        EXIT /B %RC%
        '''
    }
}
        stage('Health Check') {
    steps {
        bat 'curl -i %APP_URL%'
    }
}
    }

        post {
            success {
                archiveArtifacts artifacts: 'publish/**', fingerprint: true
            mail to: 'itcoblr.dev@muthootgroup.com,itvishal.n@muthootgroup.com,itcoblr@muthootgroup.com',
                 subject: "✅ Deployment Successful | ${env.JOB_NAME} | Build #${env.BUILD_NUMBER}",
            body: """
Hello Team,

The application deployment has completed successfully.

Deployment Details:
----------------------------------------
Job Name      : ${env.JOB_NAME}
Build Number  : ${env.BUILD_NUMBER}
Status        : SUCCESS
Triggered By  : Jenkins
Build URL     : ${env.BUILD_URL}
Deployment Time : ${new Date()}

The latest application version has been deployed successfully to the target environment.

Regards,
IT Team
"""
        }
        failure {
            bat '''
            echo Deployment failed. Starting rollback...

            iisreset /stop

            robocopy "%BACKUP_PATH%" "%APP_PATH%" /MIR

            iisreset /start
            '''
            mail to: 'itcoblr.dev@muthootgroup.com,itvishal.n@muthootgroup.com,itcoblr@muthootgroup.com',
                subject: "❌ Deployment Failed | ${env.JOB_NAME} | Build #${env.BUILD_NUMBER}",
            body: """
Hello Team,

The deployment has failed and requires attention.

Failure Details:
----------------------------------------
Job Name      : ${env.JOB_NAME}
Build Number  : ${env.BUILD_NUMBER}
Status        : FAILED
Build URL     : ${env.BUILD_URL}
Failure Time  : ${new Date()}

Please review the Jenkins console logs for detailed error information.

Regards,
IT Team
"""
        }
    }    
}
