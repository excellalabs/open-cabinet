podTemplate(label: 'open-cabinet', containers: [
  containerTemplate(name: 'ruby', image: 'ruby:2.2.9', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker:dind', command: 'cat', ttyEnabled: true, privileged: true),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:latest', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:latest', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'aws', image: 'mesosphere/aws-cli', command: 'cat', ttyEnabled: true,
  envVars: [
  secretEnvVar(key: "AWS_ACCESS_KEY_ID", secretName: 'awscreds', secretKey: 'access_key'),
  secretEnvVar(key: "AWS_SECRET_ACCESS_KEY", secretName: 'awscreds', secretKey: 'secret_key')
  ])
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node('open-cabinet') {
    stage('Test') {
      container('ruby') {
        checkout scm
        sh """
        #bundle install
        #RAILS_ENV=test bundle exec rake test
        """
      }
    }
    stage('Build') {
      def ecr_login = ""
      container('aws') {
        sh "aws ecr get-login --no-include-email --region us-east-1 > login.txt"
        ecr_login = readFile('login.txt')
      }
      container('docker') {
        checkout scm
        withEnv(["ecr_login=${ecr_login}"])  {
          sh '''
        ${ecr_login}
        docker build -t open-cabinet .
        docker tag open-cabinet:latest 788232951588.dkr.ecr.us-east-1.amazonaws.com/open-cabinet:latest
        docker push 788232951588.dkr.ecr.us-east-1.amazonaws.com/open-cabinet:latest
        '''
      }
      }
    }
  }
}
