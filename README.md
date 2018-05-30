# Ansible control node on Centos 7 base image

## Build docker base image
```
docker build -t ansible-control .
git tag -a "2.4.2.0" -m "Ansible version 2.4.2.0"
git push
git push --tags
```

```
docker build -t ansible-control:2.5 -t ansible-control:latest .
git tag -a "2.5" -m "Ansible version 2.5"
git push
git push --tags
```

```
docker build -t ansible-control:2.5.3 -t ansible-control:latest .
git add Dockerfile README.md VERSION requirements.txt
git tag -a "2.5.3" -m "Ansible version 2.5.3"
git push
git push --tags
```
