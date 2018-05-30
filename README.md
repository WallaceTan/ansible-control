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
git tag -a -m "Ansible version 2.5" "2.5" 7c2b8736f5c17c9eb9d71ba39b00798dd0bf57ca
git push
git push --tags
```

```
docker build -t ansible-control:2.5.3 -t ansible-control:latest .
git add Dockerfile README.md VERSION requirements.txt
git commit -m "Ansible version 2.5.3"
git push origin
git tag -a -m "Ansible version 2.5.3" "2.5.3"
git push --tags
```
