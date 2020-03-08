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
   
   when finished bucket can be showed on http://localhost:9001 
   
   user: minio
   
   password: minio123
   
   cleanup
   
   ```
   docker-compose -f minio/docker-compose.yml down -v
   ```

4. google project credentials_key.json required for running terraform
   ```
   export GOOGLE_CLOUD_KEYFILE_JSON=key.json
   ```
   
   from terraform folder

```terraform
   terraform init 
   terraform plan 
   terraform apply
 ```
