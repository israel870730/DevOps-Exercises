# terragrunt
Ejercicios de Terraform usando Terragrunt

# Export the profile 
# First export the profile.
export AWS_PROFILE=poc

# If you want also can export the region
export AWS_DEFAULT_REGION=us-east-1

# Update the .kube/config file to acces inside the cluster
aws eks update-kubeconfig --region us-west-1 --name demo --profile poc

# Si estoy dentro de un modulo especifico
terragrunt plan
terragrunt apply
terragrunt destroy

# Si quiero ejecutar varios modulos al mismo tiempo
terragrunt run-all apply
terragrunt run-all destroy

# Para eliminar la cache de terragrunt
find ./ -type f -name .terraform.lock.hcl | xargs rm -rf
find ./ -type d -name .terragrunt-cache | xargs rm -rf

# Para ver los pod y los nodos al mismo tiempo
watch -n 1 'kubectl get po -o wide  && kubectl get node'
watch -n 10 'kubectl get po -A && kubectl get node'