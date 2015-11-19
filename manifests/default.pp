
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
      'network.host'             => $::ipaddress,
      'http.cors.enabled'        => true,
    }
  }

  elasticsearch::instance { "es01":
    datadir        => "/var/lib/es-data-$hostname",
  }

  elasticsearch::instance { "$hostname":
    ensure         => absent
  }

  elasticsearch::template { "template":
    ensure         => absent
  #  content        => '{"template":"*","settings":{"number_of_replicas":1}}',
  #  host           => $::ipaddress,
  #  port           => 9200
  }

  elasticsearch::plugin { 'royrusso/elasticsearch-hq/v2.0.3':
    instances      => 'es01'
  }

  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf/2.0':
    instances      => 'es01'
  }

}


