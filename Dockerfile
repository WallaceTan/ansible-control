FROM centos:latest

RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools python-pip git vim wget tree openssh-client jq traceroute && \
    yum -y install --enablerepo=epel ansible

RUN useradd ansible && \
    mkdir /home/ansible/.ssh && \
    chown ansible:ansible /home/ansible/.ssh

RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
RUN pip install --upgrade pip awscli boto boto3

ENV TZ=Asia/Singapore

# tail is running in the foreground to keep container running
CMD ["tail", "-f", "/dev/null"]
