CERTIFICATE_AUTHORITY=`cat /root/.minikube/ca.crt | base64 | sed -z 's/\n//g'`
CLIENT_CERTIFICATE=`cat /root/.minikube/profiles/minikube/client.crt | base64 | sed -z 's/\n//g'`
CLIENT_KEY=`cat /root/.minikube/profiles/minikube/client.key | base64 | sed -z 's/\n//g'`

kubectl config view --minify | sed \
	-e "s^certificate-authority:^certificate-authority-data:^g" \
	-e "s^/root/.minikube/ca.crt^${CERTIFICATE_AUTHORITY}^g" \
	-e "s^client-certificate:^client-certificate-data:^g" \
	-e "s^/root/.minikube/profiles/minikube/client.crt^${CLIENT_CERTIFICATE}^g" \
	-e "s^client-key:^client-key-data:^g" \
	-e "s^/root/.minikube/profiles/minikube/client.key^${CLIENT_KEY}^g"
