DOCKERHUB_USER=iyuichivm
BUILD_TIMESTAMP=test

kubectl apply -f ../k8s/db/deployment.yml
kubectl apply -f ../k8s/db/service.yml

sed -e "s/{{DOCKERHUB_USER}}/${DOCKERHUB_USER}/g" -e "s/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g" ../k8s/back/deployment.yml | kubectl apply -f -
kubectl apply -f ../k8s/back/service.yml

sed -e "s/{{DOCKERHUB_USER}}/${DOCKERHUB_USER}/g" -e "s/{{BUILD_TIMESTAMP}}/${BUILD_TIMESTAMP}/g" ../k8s/front/deployment.yml | kubectl apply -f -
kubectl apply -f ../k8s/front/service.yml