# tomcat-openshift
Example to use tomcat docker image in openshift  
First look to https://github.com/apache/tomcat/tree/master/res/tomcat-maven  
The tomcat-openshift is just explaining how to use the image in OpenShift and demo it.  
mvn install  
docker build -t tomcat-demo .  
docker run --rm -p 8080:8080 -it tomcat-demo  
curl -v http://172.17.0.1:8080/demo-1.0/demo  
