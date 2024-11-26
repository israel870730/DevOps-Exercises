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

# Para eliminar la cache de terraform
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

- Borrar todos los recursos en el cluster
    - kubectl delete all --all --all-namespaces --grace-period=0 --force

- Forzar eliminación de recursos problemáticos
  - kubectl delete pod <pod-name> --grace-period=0 --force -n <namespace>

- Para aplicar esto a todos los pods en un namespace:
  - kubectl get pods -n <namespace> -o name | xargs kubectl delete --grace-period=0 --force

- Eliminar un Ingress específico
  - kubectl delete ingress <ingress-name> --grace-period=0 --force -n <namespace>

- Eliminar todos los Ingress en un namespace
  - kubectl get ingress -n <namespace> -o name | xargs kubectl delete --grace-period=0 --force -n <namespace>
  
- Eliminar todos los Ingress en todas las namespaces
  - kubectl get ingress --all-namespaces -o name | xargs kubectl delete --grace-period=0 --force
  - kubectl delete --grace-period=0 --force ingress example-app-1-ingress -n poc 

