# Terraform folder

# Export the profile 
# First export the profile.
export AWS_PROFILE=poc

# If you want also can export the region
export AWS_DEFAULT_REGION=us-east-1

# Update the .kube/config file to acces inside the cluster
aws eks update-kubeconfig --region us-west-1 --name demo --profile poc

# Si estoy dentro de un modulo especifico
terraform plan
terraform apply
terraform destroy

# Para eliminar la cache de terragrunt
find ./ -type f -name .terraform.lock.hcl | xargs rm -rf
find ./ -type d -name .terraform | xargs rm -rf

# Para ver los pod y los nodos al mismo tiempo
watch -n 1 'kubectl get po -o wide  && kubectl get node'
watch -n 10 'kubectl get po -A && kubectl get node'


# Tags to All Resources on Terraform
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging#propagating-tags-to-all-resources
https://developer.hashicorp.com/terraform/tutorials/aws/aws-default-tags

# Acceder a una instancia desde la consola usando el SSM
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
aws ssm start-session --target inastance-ID --region eu-west-2