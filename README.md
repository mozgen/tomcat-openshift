# tomcat-openshift
Example to use tomcat docker image in openshift  
First look to https://github.com/apache/tomcat/tree/master/res/tomcat-maven  
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
