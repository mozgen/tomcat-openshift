# tomcat-openshift
Example to use tomcat docker image in openshift  
First look to https://github.com/apache/tomcat/tree/master/res/tomcat-maven  
The tomcat-openshift is just explaining how to use the image in OpenShift and demo it.  
mvn install  
docker build -t docker.io/jfclere/tomcat-demo .  
docker push jfclere/tomcat-demo  

To test the tomcat-demo localy:  
docker run --rm -p 8080:8080 --env "KUBERNETES_NAMESPACE=tomcat-demo" -it docker.io/jfclere/tomcat-demo  

# connect to openshift using DNSPing
oc new-project tomcat-demo  
oc create -f deployment.yaml  
oc scale --replicas=2 deployment tomcat-demo  
oc create -f service.yaml  

# connect to openshift using KUBEPing: (DRAFT) 

With Adding permission:  

oc policy add-role-to-user view system:serviceaccount:tomcat-demo:default -n tomcat-demo  

oc run tomcat-demo --image=docker.io/jfclere/tomcat-demo --port=8080  

oc scale dc tomcat-demo --replicas=2  

oc expose dc tomcat-demo --type=LoadBalancer  

oc get services  

[jfclere@localhost demo-webapp]$ oc get services  
NAME          TYPE           CLUSTER-IP     EXTERNAL-IP                                                              PORT(S)          AGE  
tomcat-demo   LoadBalancer   172.30.75.90   af1876aeaaef711e98cff1212969a920-441917139.us-east-1.elb.amazonaws.com   8080:30138/TCP   67s   

curl -v http://af1876aeaaef711e98cff1212969a920-441917139.us-east-1.elb.amazonaws.com:8080/demo-1.0/demo

[jfclere@localhost demo-webapp]$ oc policy add-role-to-user view system:serviceaccount:tomcat-demo:default -n tomcat-demo
role "view" added: "system:serviceaccount:tomcat-demo:default"
[jfclere@localhost demo-webapp]$ oc run tomcat-demo --image=docker.io/jfclere/tomcat-demo --port=8080
deploymentconfig.apps.openshift.io/tomcat-demo created

