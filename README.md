# Ansible control node on Centos 8 base image

## Build docker base image
```
docker build -t ansible-control:2.9.6 -t ansible-control:latest .
git tag -a "2.9.6" -m "Ansible version 2.9.6 and Centos8"
git push
git push --tags
```
