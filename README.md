# tomcat-openshift
Example to use tomcat docker image in openshift  
First look to https://github.com/apache/tomcat/tree/master/res/tomcat-maven  
The tomcat-openshift is just explaining how to use the image in OpenShift and demo it.  
mvn install  
docker build -t tomcat-demo .  
docker run --rm -it tomcat-demo -p 8080:8080  
