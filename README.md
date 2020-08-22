# tomcat-openshift
Example to use tomcat docker image in openshift  
First look to https://github.com/apache/tomcat/tree/master/res/tomcat-maven  
For multi-plaform add :platform like jfclere/tomcat-demo:aarch64 to the docker URL.
The tomcat-openshift is just explaining how to use the image in OpenShift and demo it.  
```bash
mvn install  
docker build -t docker.io/jfclere/tomcat-demo .  
docker push docker.io/jfclere/tomcat-demo  
```

To test the tomcat-demo localy (java.net.UnknownHostException: tomcat-demo: Name does not resolve is expected):  
```bash
docker run --rm -p 8080:8080 --env "KUBERNETES_NAMESPACE=tomcat-demo" -it docker.io/jfclere/tomcat-demo  
```

# connect to openshift using DNSPing 
```bash
oc new-project tomcat-demo
oc process -f deployment.yaml KUBERNETES_NAMESPACE=`oc project -q` DOCKER_URL=docker.io/jfclere/tomcat-demo | oc create -f -
oc create -f service.yaml  
oc scale --replicas=2 deployment tomcat-demo  
oc create -f route.yaml  
```

Read the URL for demo:  
```
[jfclere@localhost tomcat-openshift]$ oc get routes
NAME          HOST/PORT                                                             PATH      SERVICES      PORT      TERMINATION   WILDCARD
tomcat-demo   tomcat-demo-tomcat-demo.apps.us-east-1.online-starter.openshift.com             tomcat-demo   http                    None
```


# connect to openshift using KUBEPing: (you need to have the permission to create the serviceaccount)

Change in conf/server.xml DNSMembershipProvide to KubernetesMembershipProvider and rebuild the Docker image:
```bash
docker build -t docker.io/jfclere/tomcat-demo .  
docker push docker.io/jfclere/tomcat-demo  
```

Create the service account:
```bash
oc new-project tomcat-demo
oc policy add-role-to-user view system:serviceaccount:tomcat-demo:default -n tomcat-demo  
```

Then it is like DNSPing:
```bash
oc process -f deployment.yaml KUBERNETES_NAMESPACE=`oc project -q` DOCKER_URL=docker.io/jfclere/tomcat-demo | oc create -f -
oc create -f service.yaml  
oc scale --replicas=2 deployment tomcat-demo  
oc create -f route.yaml  
```

# Using kubernetes

```bash
kubectl create namespace tomcat-demo
kubectl config set-context --current --namespace=tomcat-demo
kubectl create -f kube-tomcat-demo.yaml
kubectl create -f service.yaml
kubectl expose deployment tomcat-demo --type=LoadBalancer --name=tomcat-balancer
```

Note:
```bash
root@pc-12 tomcat-openshift]# kubectl get svc
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
tomcat-balancer   LoadBalancer   10.100.57.140   <pending>     8080:32567/TCP   4m6s
tomcat-demo       ClusterIP      None            <none>        80/TCP           31m
```
\<pending\> is NORMAL, use curl (or browser to port 32567) to test.

# Quick demo
The demo assumes that you have a running cluster and the corresponding $HOME/.kube/config
```bash
bash startdemo.sh
```
Wait until the services are created.
```bash
[root@pc-79 tomcat-openshift]# kubectl get svc
NAME              TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
tomcat-balancer   LoadBalancer   10.99.220.176   <pending>     8080:31533/TCP   4m16s
tomcat-demo       ClusterIP      None            <none>        80/TCP           4m17s
```
Then configure and restart httpd with the port in the /etc/httpd/conf/proxy.conf file:
```bash
bash startbrower.sh
```
Use a browser with json viewer on the box...
