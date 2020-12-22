#stop and disable firewalld and selinux
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
# add centos7 epel repository
yum install -y epel-release
# install apache if not exist
sudo yum install -y httpd
# install nginx if not exist
sudo yum install -y nginx
# disable apache port 80
sudo sed -i "s/Listen 80/#Listen 80/g" "/etc/httpd/conf/httpd.conf"
# create dirs, copy and modify index.html
for i in `seq 0 2`
do
  sudo mkdir "/var/www/808$i"
  sudo cp /usr/share/httpd/noindex/index.html "/var/www/808$i/"
  sudo sed -i "s/123/808$i/g" "/var/www/808$i/index.html"
  # generate apache config file
  apacheConfPath="/etc/httpd/conf.d/808$i.conf"
  echo "<VirtualHost *:808$i>" > $apacheConfPath
  echo "ServerAdmin webmaster@localhost" >> $apacheConfPath
  echo "DocumentRoot /var/www/808$i" >> $apacheConfPath
  echo "</VirtualHost>" >> $apacheConfPath
  # modify httpd.conf
  echo "Listen 808$i" >> "/etc/httpd/conf/httpd.conf"
done
# enable and start apache
sudo systemctl enable httpd && sudo systemctl start httpd
# generate nginx config
nginxConfPath="/etc/nginx/conf.d/upstream.conf"
echo "upstream httpd {" > $nginxConfPath
echo "server localhost:8080;" >> $nginxConfPath
echo "server localhost:8081;" >> $nginxConfPath
echo "server localhost:8082;" >> $nginxConfPath
echo "}" >> $nginxConfPath
# enable reverse proxy
sed -i 's/location \/ {/location \/ { proxy_pass http:\/\/httpd;/g' /etc/nginx/nginx.conf
# enable and start nginx
systemctl enable nginx && sudo systemctl start nginx
