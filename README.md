ELK

test logstash pipeline config 
switch to auto config
filter groc fields

apply filebeat focus on fields ?

Logstash to ES Cluster:
elastic.co/guide/en/logstash/5.5/plugins-outputs-elasticsearch.html#plugins-outputs-elasticsearch-hosts

Installing Logstash:
https://www.elastic.co/guide/en/logstash/6.8/installing-logstash.html

Grok config
https://www.elastic.co/guide/en/logstash/6.8/plugins-filters-grok.html

S3 to elk
https://www.elastic.co/blog/getting-aws-logs-from-s3-using-filebeat-and-the-elastic-stack


logstash:
/usr/share/logstash/bin/logstash -f  /etc/logstash/conf.d/ssm_pipeline.conf --config.reload.automatic
systemctl stop logstash
to configure logsatsh at instance reboot :
vim /etc/systemd/system/logstash.service
change ExceStart with 
ExecStart=/usr/share/logstash/bin/logstash "--path.settings=/etc/logstash/config"

voir les log du service logstash:
journalctl -u logstash.service -f

ensuite c systemctl restart logstash.service
Liste des pattern logstash
https://github.com/elastic/logstash/blob/v1.4.2/patterns/grok-patterns

network config for /etc/elasticsearch/elasticsearch.yml
transport.host: localhost
transport.tcp.port: 9300
http.port: 9200
network.host: 0.0.0.0

The Grok Debugger
http://grokdebug.herokuapp.com/



Choses à résoudre:
- Logstash ne démarre pas au reboot
- Last values dans le dashboard
- authentification

Config:
https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-settings.html#unicast.hosts
