pipeline {
  agent {
    kubernetes {
      label 'ruby'
      containerTemplate {
        name 'ruby'
        image 'ruby'
        ttyEnabled true
        command 'cat'
      }
    }
  }
  stages {
    stage "Testing" {
      steps {
        sh "bundle install"
        sh "bundle exec rake test"
      }
    }
  }
}
