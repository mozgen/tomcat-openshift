PORT=`kubectl get service | grep LoadBalancer | sed 's!:! !' | sed 's!\/! !' | awk ' { print $6 } '`
echo "curl -v http://master:$PORT/"
echo "" > /etc/httpd/conf/proxy.conf
echo "ProxyPass \"/\" \"balancer://local\"" >> /etc/httpd/conf/proxy.conf
echo "ProxyPassReverse \"/\" \"balancer://local\"" >> /etc/httpd/conf/proxy.conf
echo "" >> /etc/httpd/conf/proxy.conf
echo "<Proxy \"balancer://local\">" >> /etc/httpd/conf/proxy.conf
echo "    BalancerMember \"http://master:${PORT}\"" >> /etc/httpd/conf/proxy.conf
echo "    BalancerMember \"http://green:${PORT}\"" >> /etc/httpd/conf/proxy.conf
echo "    BalancerMember \"http://blue:${PORT}\"" >> /etc/httpd/conf/proxy.conf
echo "</Proxy>" >> /etc/httpd/conf/proxy.conf

systemctl restart httpd

echo "curl -v http://jfcportal/"
