Pipeline {
    agent any
    script {
       currentBuild.displayName = "First github run"
       currentBuild.description = "Hello world"
      }
    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
