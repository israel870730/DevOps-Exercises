KubeTips

1- kubectx y kubens:
desde que conoci este par de herramientas debo reconocer que mi productivida mejoro considerablemente,
si tienes varios cluster es vital saber sobre cual estas situado a la hora de hacer un cambio o consultar alguna informacion y para eso 
kubectx es esencial, con kubens vas a poderte mover por los diferentes namespace del cluster sin problemas.

#################################################################################################################################
2- Si no quieres instalar lo mencionado en el paso anterior y precisas saber en que cluster o ns estas, estos son los comandos:

Para ver el contexto actual:
kubectl config current-context

Para cambiar de contexto:
kubectl config use-context reno-dev3-cluster

Por defecto en el cluster siempre vamos a estar situados sobre el "namespace" default, pero puede que en algun momentos queramo cambiar de NS:
kubectl config set-context --current --namespace=kube-system
kubectl config set-context --current --namespace=default

#################################################################################################################################
3- Alias
No soy muy fan de usar "alias", pero si contamos la cantidad de veces que ejecutamos kubectl en el dia nos damos cuenta que utilizarlo en este caso es realmente util.
Aqui un par de jemplos:
alias allpods='kubectl get pods -A'
alias switchlogs='kubectl logs -n switch-runtime-int'
alias kgn='kubectl get nodes -L beta.kubernetes.io/arch -L eks.amazonaws.com/capacityType -L beta.kubernetes.io/instance-type -L eks.amazonaws.com/nodegroup -L topology.kubernetes.io/zone'

#################################################################################################################################
4- kubectl event:
Saber los eventos que estan pasando en tu cluster es vital, pero el problema es que si no ordenamos esos eventos mas que una ayuda se convierte en un verdadero
dolor de cabeza, ahi es cuando entra 
"kubectl -n name get events --sort-by='.metadata.creationTimestamp'"

#################################################################################################################################
5- kubectl logs:
kubectl logs -n switch-runtime-int
Puedo ver los log del un pod o los log de todo un deployment

kubectl -n kube-system logs -f deployment/cluster-autoscaler
kubectl logs -f deploy/lacework-agent-cluster -n lacework

Para ver los log de los pod de un daemonset:
kubectl logs -f daemonset/lacework-agent -n lacework

#################################################################################################################################
6- Kubectl top
Utilizar este comando es realmente util para analizar la carga en tiempo real de nuestro nodos y pods
Kubectl top node && Kubectl top pod

Nota: Para poder hacer uso de este comando previamente es necesario deployar el deployment "metrics server"

#################################################################################################################################
7- kubectl rollout
Muchas veces precisamos por alguna razon precisamos reiniciar nuestro deployment
kubectl rollout restart deployment php-apache

#################################################################################################################################
8- kubectl describe:
Puedo ver informacion relevante del recurso 

#################################################################################################################################
9- kubectl edit:
No es lo mas recomendado pero quizas precises editar tu deployment por alguna razon y ahi entra en escena 
kubectl --context test-core edit deploy -n kube-system metrics-server

#################################################################################################################################
10-  Como ver todos los tag de un deployment y filtrar sus pod
kubectl get deploy reno-recon-file-handler -n reno-cloud -o wide
kubectl get pods -l app=mi-aplicacion (kubectl get pods -n reno-cloud -l app.kubernetes.io/name=reno)

#################################################################################################################################
11- kubectl port-forward:
Para hacer un tunnel y poder conectarse al dashboard de EKS que viene por defecto:
kubectl.exe port-forward --context dev-core -n kubernetes-dashboard service/kubernetes-dashboard 8443:443                                                   
Luego en el navegador 
Localhost:8443

#################################################################################################################################
12 - Para ver que permisos tiene el usuario que esta logueado en el cluster, podemos cambiar el tipo de verbo y recurso:
kubectl auth can-i get po
kubectl auth can-i create deployment

Para ver que permisos tiene sobre un determinado NS
kubectl auth can-i get po -n integration

kubectl auth can-i "*" "*"

#################################################################################################################################
13- Crear una imagen docker para hacer troubleshooting
Esto es realmente util para hacer troubleshooting dentro de nuestro cluster, 
muchas veces cuando tenemos un problema entramos a un pod del cluster y terminamos instalandole diferentes herramietas para analizar que esta pasando,
el problema es que cuando es pod se elimina tenemos que hecer lo mismo de vuelta y termina convirtiendose en un ciclo bastante tedioso,
por eso mi recomendacion es hacerse una imagen doccker para hacer troubleshooting, ponerla en el docker hub o en algun repositorio local de imagenes
y cada ves que tenemos un problema hacer uso de ella.

kubectl run tmp -it --restart=Never --image=870730/troubleshooting:v1.2 --tty --rm /bin/sh

#################################################################################################################################
14- Ejecutar kubectl y leer la ayuda del comando, 
no es facil aprenderse todos los comando para trabajr con K8S, por eso es muy bueno saber interactuar con la ayuda del comando kubectl y con la ayuda de K8S en general

Ayuda en línea de comandos: Aprender a utilizar la ayuda que nos ofrece la línea de comandos de Kubernetes, con comandos como 'explain' y 'help', 
nos permite aclarar dudas rápidamente y nos vuelve más ágiles a la hora de trabajar.


