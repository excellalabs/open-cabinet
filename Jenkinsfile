def test_environment = "open-cabinet-test-${UUID.randomUUID().toString()}"

podTemplate(label: 'open-cabinet', containers: [
  containerTemplate(name: 'ruby', image: 'ruby:2.2.9', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker:dind', command: 'cat', ttyEnabled: true, privileged: true),
  containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:latest', command: 'cat', ttyEnabled: true,
  envVars:[
    envVar(key: 'TEST_NAMESPACE', value: test_environment)
  ]),
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
    stage('Static Analysis') {
      container('ruby') {
        checkout scm
        sh """
        bundle install
        rubocop
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
        docker tag open-cabinet 788232951588.dkr.ecr.us-east-1.amazonaws.com/open-cabinet:${BUILD_NUMBER}
        docker push 788232951588.dkr.ecr.us-east-1.amazonaws.com/open-cabinet:${BUILD_NUMBER}
        '''
        }
      }
    }
    try {
      stage('Deploy Testing') {
        container('kubectl') {
          checkout scm
          // Deploy to random environment
          sh '''
          kubectl create namespace ${TEST_NAMESPACE}
          kubectl create -f kube/services/postgres.yaml --namespace=${TEST_NAMESPACE}
          kubectl create -f kube/deployments/postgres-ephemeral.yaml --namespace=${TEST_NAMESPACE}
          cat kube/deployments/rails.yaml | sed s/latest/${BUILD_NUMBER}/g | kubectl apply --namespace=${TEST_NAMESPACE} -f -
          '''
        }
      }

      container('ruby') {
        stage('Unit Test') {
          checkout scm
          // these tests are dependent on a database, which is bad. Otherwise this would be done before the build
          echo 'testing is not in scope'
          // sh """
          // bundle install
          // export SECRET_KEY_BASE=9dc0d800af4c46f1ff3881c5d5d6fd31bd2c04f90922572f5cbf940546342d5c0b1607387f14c6efad1575961dfda2b3c325234e841f3c61f6037241c11ad85f
          // RAILS_ENV=test bundle exec rspec
          // """
        }
        stage('Acceptance Test') {
          echo 'acceptance tests are currently broken'
          // acceptance tests are broken right now
          // sh '''
          // RAILS_ENV=test cucumber
          // '''
        }
        stage('Security Scan') {
          sh '''
          echo 'security scan is out of scope'
          '''
        }
        stage('Integration Test') {
          sh '''
          echo 'integration tests are also out of scope'
          '''
        }
      }
    } finally {
      container('kubectl') {
        checkout scm
        sh 'kubectl describe namespace ${TEST_NAMESPACE} && kubectl delete namespace ${TEST_NAMESPACE}'
      }
    }
    stage('Deploy Staging') {
      container('kubectl') {
        checkout scm
        sh '''
        kubectl apply -f kube/volumes/postgres.yaml --namespace=staging
        kubectl apply -f kube/services/postgres.yaml --namespace=staging
        kubectl apply -f kube/deployments/postgres.yaml --namespace=staging

        kubectl apply -f kube/jobs/setup.yaml --namespace=staging

        cat kube/deployments/rails.yaml | sed s/latest/${BUILD_NUMBER}/g | kubectl apply --namespace=staging -f -
        kubectl apply -f kube/services/rails.yaml --namespace=staging
        kubectl apply -f kube/ingresses/rails.yaml --namespace=staging
        '''
      }
    }
    stage('Deploy Production') {
      container('kubectl') {
        checkout scm
        sh '''
        kubectl apply -f kube/volumes/postgres.yaml --namespace=production
        kubectl apply -f kube/services/postgres.yaml --namespace=production
        kubectl apply -f kube/deployments/postgres.yaml --namespace=production

        kubectl apply -f kube/jobs/setup.yaml --namespace=production

        cat kube/deployments/rails.yaml | sed s/latest/${BUILD_NUMBER}/g | kubectl apply --namespace=production -f -
        kubectl apply -f kube/services/rails.yaml --namespace=production
        kubectl apply -f kube/ingresses/rails.yaml --namespace=production
        '''
      }
    }
  }
}
