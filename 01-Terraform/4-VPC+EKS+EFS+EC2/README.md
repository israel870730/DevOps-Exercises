# Notas
aws eks --region us-west-1 update-kubeconfig --name poc-eks --alias poc-deploy

https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
https://docs.aws.amazon.com/eks/latest/userguide/helm.html


# EC2
Conectarse a la instancia usando el SSM:
1- aws ssm start-session --target Instance-ID --region us-west-1

2- Antes de exportar estas variables tengo que exportar las credenciales de AWS en la instancia de EC2
- Chequear quien esta conectado
 - aws sts get-caller-identity
- Exportar el rol y las credenciales 
credentials=$(aws sts assume-role --role-arn arn:aws:iam::012345678901:role/TerraformRole-Eks --role-session-name "demo" | jq ".Credentials")
export AWS_ACCESS_KEY_ID=$(echo $credentials | jq -r ".AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(echo $credentials | jq -r ".SecretAccessKey")
export AWS_SESSION_TOKEN=$(echo $credentials | jq -r ".SessionToken")

3- Aptualizar el kubeconfig
aws eks --region us-west-1 update-kubeconfig --name demo-eks --alias demo-eks

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN


# EFS
1- Steps to install CSI driver using Helm
helm repo add aws-efs-csi-driver  https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system

Run the following command to verify that the aws-efs-csi-driver has started.
kubectl get pod -n kube-system -l "app.kubernetes.io/name=aws-efs-csi-driver,app.kubernetes.io/instance=aws-efs-csi-driver"

2- Obtener el id del EFS
aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text --region us-west-1

# Montar el EFS en Amazon Linux
- yum install amazon-efs-utils -y
- mkdir /opt/efs
- cd /opt
- Despues ir al EFS en AWS y en "Attach" copiar los detalles para montarlo



kubectl exec -ti app1 -- tail /data/out1.txt
kubectl exec -ti app2 -- tail /data/out2.txt
kubectl exec -ti app2 -- ls -l /data/


https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v17.24.0/examples/secrets_encryption/main.tf