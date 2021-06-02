FROM jenkins/jenkins:2.277.4-lts-centos7
USER root

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum -y install epel-release \
    && yum --enablerepo=epel install -y yum-utils device-mapper-persistent-data lvm2 docker-ce-cli sshpass \
    && rm -rf /var/cache/yum/* && yum clean all
RUN curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.20.7/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

COPY --chown=jenkins:jenkins ./jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod 0775 /usr/local/bin/jenkins.sh

COPY --chown=jenkins:jenkins ./secrets/dockerhost_password.txt /secrets/dockerhost_password.txt
COPY --chown=jenkins:jenkins ./secrets/dockerhub_password.txt /secrets/dockerhub_password.txt
COPY --chown=jenkins:jenkins ./secrets/dockerhub_secret.yml /secrets/dockerhub_secret.yml
COPY --chown=jenkins:jenkins ./secrets/kubeconfig /secrets/kubeconfig

USER jenkins
ENV JAVA_OPTS -Djava.awt.headless=true -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Tokyo -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8
EXPOSE 8080 50000
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]