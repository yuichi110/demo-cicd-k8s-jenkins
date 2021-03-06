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
        sh "test -e /secrets/dockerhub_password.txt"
        sh "test -e /secrets/dockerhost_password.txt"
        sh "test -e /secrets/kubeconfig"
        sh "test -e /secrets/dockerhub_secret.yml"
      }
    }

    stage('CI:Build') {
      steps {
        sh "/bin/bash -c \"cat /secrets/dockerhub_password.txt | docker login --username ${DOCKERHUB_USER} --password-stdin\""
        sh "sshpass -f /secrets/dockerhost_password.txt ssh-copy-id ${BUILD_HOST}"
        sh "/bin/bash -c \"docker context create remote --docker 'host=ssh://${BUILD_HOST}'; echo\""
        sh "docker context use remote"

        sh "docker-compose -f build.yml build"
        sh "docker tag demo-cicd-k8s-jenkins-front ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-front:${BUILD_TIMESTAMP}"
        sh "docker tag demo-cicd-k8s-jenkins-back ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-back:${BUILD_TIMESTAMP}"
        sh "docker push ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-front:${BUILD_TIMESTAMP}"
        sh "docker push ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-back:${BUILD_TIMESTAMP}"
      }
    }
    
    stage('CD:Deploy') {
      steps {
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/db/deployment.yml'
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/db/service.yml'
        sh "/bin/bash -c \"sed -e 's/{{DOCKERHUB_USER}}/${DOCKERHUB_USER}/g' -e 's/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g' ./k8s/back/deployment.yml | kubectl --kubeconfig /secrets/kubeconfig apply -f -\""
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/back/service.yml'
        sh "/bin/bash -c \"sed -e 's/{{DOCKERHUB_USER}}/${DOCKERHUB_USER}/g' -e 's/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g' ./k8s/front/deployment.yml | kubectl --kubeconfig /secrets/kubeconfig apply -f -\""
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/front/service.yml'
      }
    }
  }
}