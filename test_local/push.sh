DOCKERHUB_USER=iyuichivm
BUILD_TIMESTAMP=test

# tag
docker tag demo-cicd-k8s-jenkins-front ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-front:${BUILD_TIMESTAMP}
docker tag demo-cicd-k8s-jenkins-back ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-back:${BUILD_TIMESTAMP}

# push
docker push ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-front:${BUILD_TIMESTAMP}
docker push ${DOCKERHUB_USER}/demo-cicd-k8s-jenkins-back:${BUILD_TIMESTAMP}
