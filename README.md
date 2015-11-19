# vagrant-elastic
ElasticSearch cluster of 3 machines started by Vagrant

Configuration of the cluster is via https://forge.puppetlabs.com/elasticsearch/elasticsearch puppet module
Also there are 2 GUIs installed:

* https://github.com/lmenezes/elasticsearch-kopf
* https://github.com/royrusso/elasticsearch-HQ

The cluster is set to use the 1st node for unicast discovery and not to use multicast

