
## ES nodes

node /^el\d+/ {
  package { "vim-enhanced": ensure => 'installed', }
  package { "git"         : ensure => 'installed', }
  package { "acpid"       : ensure => 'installed', }
  package { "nss"         : ensure => 'latest',    }


  class { 'elasticsearch': 
    manage_repo    => true,
    java_install   => true,
    repo_version   => '2.0',
    config => {
      'cluster.name'             => 'es-cluster',
      'index.number_of_replicas' => '1',
      'index.number_of_shards'   => '3',
      'network.host'             => $::ipaddress_eth1,
      'http.cors.enabled'        => true,
      'node.data'                => true,
      'node.master'              => true,
      'discovery.zen.ping.multicast.enabled' => false,
      'discovery.zen.ping.unicast.hosts' => '["192.168.124.101"]',
    }
  }

  elasticsearch::instance { "es01":
    datadir        => "/var/lib/es-data-$hostname",
  }

  elasticsearch::template { "template":
    ensure         => absent
  #  content        => '{"template":"*","settings":{"number_of_replicas":1}}',
  #  host           => $::ipaddress,
  #  port           => 9200
  }

  elasticsearch::plugin { 'mobz/elasticsearch-head':
    instances      => 'es01'
  }

  elasticsearch::plugin { 'royrusso/elasticsearch-hq/v2.0.3':
    instances      => 'es01'
  }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf/2.0':
    instances      => 'es01'
  }

}


