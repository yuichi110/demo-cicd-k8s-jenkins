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

    stage('CI:Build') {
      steps {
        sh "cat /secrets/dockerhub_password.txt | docker login --username ${DOCKERHUB_USER} --password-stdin"
        sh "sshpass -f /secrets/dockerhost_password.txt ssh-copy-id ${BUILD_HOST}"

        sh "docker-compose -H ssh://${BUILD_HOST} -f build.yml build"
        sh "docker -H ssh://${BUILD_HOST} tag demo-cicd-k8s-jenkins-front ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-front:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} tag demo-cicd-k8s-jenkins-back ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-back:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-front:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-back:${BUILD_TIMESTAMP}"
      }
    }
    
    stage('CD:Deploy') {
      steps {
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/db/deployment.yml'
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/db/service.yml'
        sh "sed -e 's/{{DOCKERHUB_USER}}/${DOCKERHUB_USER}/g' -e 's/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g' ./k8s/back/deployment.yml | kubectl --kubeconfig /secrets/kubeconfig apply -f -"
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/back/service.yml'
        sh "sed -e 's/{{DOCKERHUB_USER}}/${DOCKERHUB_USER}/g' -e 's/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g' ./k8s/front/deployment.yml | kubectl --kubeconfig /secrets/kubeconfig apply -f -"
        sh 'kubectl --kubeconfig /secrets/kubeconfig apply -f ./k8s/front/service.yml'
      }
    }
  }
}