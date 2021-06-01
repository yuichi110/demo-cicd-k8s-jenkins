pipeline {
  agent any
  environment {
    DOCKERHUB_USER = "iyuichivm"
    BUILD_HOST = "root@192.168.64.51"
    BUILD_TIMESTAMP = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
  }

  stages {
    stage('Pre Check') {
      steps {
        sh "test ./dockerhub_password.txt"
        sh "test ./dockerhost_password.txt"
        sh "test ./kubeconfig"
        sh "test ./k8s/dockerhub_secret.yml"
      }
    }

    stage('Build') {
      steps {
        sh "cat ./dockerhub_password.txt | docker login --username ${DOCKERHUB_USER} --password-stdin"
        sh "sshpass -f ./dockerhost_password.txt ssh-copy-id ${BUILD_HOST}"
        sh "docker-compose -H ssh://${BUILD_HOST} -f build.yml build"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_web ${DOCKERHUB_USER}/c8kvs_test_web:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_app ${DOCKERHUB_USER}/c8kvs_test_app:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_webtest ${DOCKERHUB_USER}/c8kvs_test_webtest:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_test_web:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_test_app:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_test_webtest:${BUILD_TIMESTAMP}"
      }
    }
    
    stage('Deploy') {
      steps {
        sh "kubectl --kubeconfig kubeconfig apply -f ./k8s/dockerhub_secret.yml"
        sh "sed 's/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g' ./front/k8s/service.yml | kubectl --kubeconfig kubeconfig apply -f -"
      }
    }
  }
}