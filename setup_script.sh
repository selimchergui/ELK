#!/bin/bash
#This following script automates the installation and configuration of a three node Elastic Stack Cluster.
#NEED TO BE RAN UNDER ROOT PRIVILEGES
#Tested on Centos

#***************************************INITIAL CONFIGURATION**************************************************

#env setup java installation
yum -y install java-openjdk-devel java-openjdk
echo $?


#**************************************ELASTICSEARCH***********************************************************

#add elk repository
cat <<EOF | sudo tee /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

#add GPG Key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
yum clean all
echo $?
yum makecache
echo $?

#ELK installation
yum -y install elasticsearch
echo $?
#Confirm installation
rpm -qi elasticsearch
#JVM configuration
#You can set JVM options like memory limits by editing the file: /etc/elasticsearch/jvm.options
#By default the heap memory size is 4GO, we increase it to 8GO
#Change the heap memory size in accordance with your usecase
sed -i 's/-Xms1g/-Xms8g/g' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx1g/-Xmx8g/g' /etc/elasticsearch/jvm.options

#ELK CLUSTER CONFIGURATION
#elasticsearch.yml : add a name to the variable : cluster.name
#TODO
sed -i -e 's/^cluster\.name: .*/cluster.name: cl-666/' elasticsearch.yml

#Enabling ELK as a Service
systemctl enable --now elasticsearch.service
echo $?
#testing the service up and running
curl http://127.0.0.1:9200
#Creating The index (Replace mytest_index)
curl -X PUT "http://127.0.0.1:9200/mytest_index"




#**********************************************LOGSTACH********************************************************

#Installation
yum -y install logstash
echo $?


#**********************************************KIBANA**********************************************************

#Kibana INSTALLATION : ONLY ON THE MASTER NODE
yum -y install kibana
echo $?

#Kibana Configurarion 
#in /etc/kibana/kibana.yml
#we need to set this variable server.host: "0.0.0.0"
sed -i -e 's/^#server\.host: .*/server.host: "myserver666"/' "/etc/kibana/kibana.yml"
#we need to set this variable server.name: "kibana.example.com"
sed -i -e 's/^#server\.name: .*/server.name: "myserver666"/' "/etc/kibana/kibana.yml"
#we need to set this variable elasticsearch.url: "http://localhost:9200"
sed -i -e 's/^#elasticsearch\.url: .*/elasticsearch.url: "http:\/\/localhost:9200"/' "/etc/kibana/kibana.yml"
# todo Variablize certficate integrtion ('acm or else')

#Enabling Kibana as a service
systemctl enable --now kibana

#add permanent tcp port 5601 if active firewall 
firewall-cmd --add-port=5601/tcp --permanent
firewall-cmd --reload

