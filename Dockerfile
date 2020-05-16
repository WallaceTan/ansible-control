FROM centos:8

RUN yum -y install epel-release && \
    yum -y install ansible which net-tools bind-utils iputils tree jq unzip && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    pip3 install awscli --upgrade
#    yum -y install python-argcomplete ansible && \
#    yum -y install PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko python-setuptools python2-pip && \
#    yum -y install git vim wget tree openssh-client jq traceroute openvpn unzip && \
#    yum -y install net-tools bind-utils && \

# ADD docker/files/requirements.txt .
# RUN pip install --upgrade pip && \
#     pip install -r requirements.txt

#RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts

# RUN useradd ansible && \
#     mkdir /home/ansible/.ssh && \
#     chown ansible:ansible /home/ansible/.ssh

# WORKDIR /tmp/ansible
# ADD docker/files/VERSION .

ENV ANSIBLE_VERSION 2.9.6
ENV TZ=Asia/Singapore


# tail is running in the foreground to keep container running
CMD ["tail", "-f", "/dev/null"]
