## ELK/Grafana Notes

##### La platefome est compsée des noeuds suivants:
• 1 Noeud C5.2xlarge Elastic + Kibana
• 1 Noeud C5.2xlarge Elastic 
• 1 Noeud C5.2xlarge Elastic + Logstash (mauvaise idée je pense)
• 1 Noeud C5.xlarge Grafana 

Bien qu'un noeud est désigné pour commencer en tant master, les 3 noeuds ES sont symétriques.
En effet, au niveau des configs (elasticsearch.yml), ils ont les même rôles (les roles: **data**, **master** et **ingest**) 

Dans des archis plus compliquées, on peut retrouver des noeuds occupants un seul rôle (coordinateur, stockage, recherche ...)

### Logstash to ES Cluster
https://www.elastic.co/guide/en/logstash/5.5/plugins-outputs-elasticsearch.html#plugins-outputs-elasticsearch-hosts

### Installing Logstash
https://www.elastic.co/guide/en/logstash/6.8/installing-logstash.html

### Grok config
https://www.elastic.co/guide/en/logstash/6.8/plugins-filters-grok.html

### S3 to elk
https://www.elastic.co/blog/getting-aws-logs-from-s3-using-filebeat-and-the-elastic-stack


logstash:
/usr/share/logstash/bin/logstash -f  /etc/logstash/conf.d/ssm_pipeline.conf --config.reload.automatic

To configure logsatsh at instance reboot :
`vim /etc/systemd/system/logstash.service`

change ExceStart: 
`ExecStart=/usr/share/logstash/bin/logstash "--path.settings=/etc/logstash/config"`

Start/stop logstash service:

`systemctl start logstash`

`systemctl stop logstash`

`systemctl restart logstash`

Voir les log du service logstash:
`journalctl -u logstash.service -f`


#### Liste des pattern logstash:
https://github.com/elastic/logstash/blob/v1.4.2/patterns/grok-patterns


### The Grok Debugger
http://grokdebug.herokuapp.com/



### Config ES:
https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-settings.html#unicast.hosts
