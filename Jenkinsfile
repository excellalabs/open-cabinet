podTemplate(label: 'open-cabinet', containers: [
  containerTemplate(name: 'ruby', image: 'ruby:2.2.9', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker:dind', command: 'cat', ttyEnabled: true, privileged: true),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:latest', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:latest', command: 'cat', ttyEnabled: true)
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node('open-cabinet') {
    stage('Test') {
      container('ruby') {
        checkout scm
        sh """
        bundle install
        bundle exec rake test
        """
      }
    }
    stage('Build') {
      container('docker') {
        checkout scm
        sh '''
        docker build .
        #$(aws ecr get-login --no-include-email --region us-east-1)
        #docker build -t open-cabinet .
        #docker tag open-cabinet:latest 788232951588.dkr.ecr.us-east-1.amazonaws.com/open-cabinet:latest)
        '''
      }
    }
  }
}
