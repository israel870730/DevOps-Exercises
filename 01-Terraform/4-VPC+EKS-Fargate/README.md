# Notas
aws eks --region us-west-1 update-kubeconfig --name poc-eks --alias poc-deploy

# Fargate
- En este caso de uso, veremos como crear un cluster de EKS unsado los "fargate_profiles", es una forma muy 
  interesante que nos propone AWS para trabajar con K8S, ya que no tendremos instancias EC2 como worker nodes.