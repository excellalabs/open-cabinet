pipeline {
  agent {
    kubernetes {
      label 'ruby'
      containerTemplate {
        name 'ruby'
        image 'ruby:2.2.9'
        ttyEnabled true
        command 'cat'
      }
    }
  }
  stages {
    stage("Testing") {
      steps {
        sh "bundle install"
        sh "bundle exec rake test"
      }
    }
  }
}
