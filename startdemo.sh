kubectl create namespace tomcat-demo
kubectl config set-context --current --namespace=tomcat-demo
kubectl create -f kube-tomcat-demo.yaml
kubectl create -f service.yaml
kubectl expose deployment tomcat-demo --type=LoadBalancer --name=tomcat-balancer
kubectl get services
kubectl get deployment
kubectl scale --replicas=2 deployment/tomcat-demo
kubectl get pods
