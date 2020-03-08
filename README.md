# anyvision_test

1. run ```./postgresh.sh``` 

   the script creates backups folder with db dumps and rsync it to /tmp

2. tested using minikube
```minikube start
   eval $(minikube docker-env)
   docker build -t nginx_ssl .
   kubectl apply -f nginx_deploy.yaml
```

3. the ansible role creates local 3 node docker minio cluster using ansible docker-compose module

   ``` ansible-playbook minio.yml```

4. credentials_key.json required for running terraform 

   from terraform folder
```terraform
   terraform init 
   terraform plan 
   terraform apply
 ```
