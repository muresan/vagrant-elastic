
## ES nodes

node /^el\d+/ {
  package { "vim-enhanced": ensure => 'installed', }
  package { "git"         : ensure => 'installed', }
  package { "acpid"       : ensure => 'installed', }
  package { "nss"         : ensure => 'latest',    }

  package { "consul":
    ensure  => 'installed',
    require => Yumrepo["consul"],
  }
  package { "consul-ui":
    ensure  => 'installed',
    require => Yumrepo["consul"],
  }
  yumrepo { 'consul':
    ensure   => present,
    baseurl  => 'http://brain.adworks.ro/consul-repo/$releasever/',
    enabled  => true,
    gpgcheck => 0,
    descr    => 'Consul and Consul-UI RPM repo',
  }

  class { 'consul':
    install_method => 'none',
    init_style     => false,
    config_hash => {
      'bootstrap_expect'   => 3,
	  'client_addr'      => '0.0.0.0',
	  'ui_dir'           => '/usr/share/consul-ui',
      'data_dir'           => '/var/lib/consul',
      'datacenter'         => 'dc1',
      'log_level'          => 'INFO',
      'server'             => true,
      'bind_addr'          => $::ipaddress_eth1,
      'rejoin_after_leave' => true,
      'start_join'         => ["192.168.124.101","192.168.124.102","192.168.124.103"],
    },
    require  => Package['consul'],
  }

  class { 'elasticsearch': 
    manage_repo    => true,
    java_install   => true,
    repo_version   => '2.x',
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
  #  host           => $::ipaddress_eth1,
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
  
  consul::service { 'elasticsearch':
    checks  => [{
      http     => "http://$::ipaddress_eth1:9200/",
      interval => '10s'
    }],
    address	=> $::ipaddress_eth1,
    port    => 9200,
    tags    => ['http'],
  }

}

node /^ls\d+/ {
  package { "vim-enhanced": ensure => 'installed', }
  package { "git"         : ensure => 'installed', }
  package { "acpid"       : ensure => 'installed', }
  package { "nss"         : ensure => 'latest',    }

  package { "consul":
    ensure  => 'installed',
    require => Yumrepo["consul"],
  }

  yumrepo { 'consul':
    ensure   => present,
    baseurl  => 'http://brain.adworks.ro/consul-repo/$releasever',
    enabled  => true,
    gpgcheck => 0,
    descr    => 'Consul and Consul-UI RPM repo',
  }

  class { 'consul':
    install_method => 'none',
    init_style     => false,
    config_hash => {
      'data_dir'           => '/var/lib/consul',
      'datacenter'         => 'dc1',
      'log_level'          => 'INFO',
      'server'             => false,
      'bind_addr'          => $ipaddress_eth1,
      'rejoin_after_leave' => true,
      'start_join'         => ["192.168.124.101","192.168.124.102","192.168.124.103"],
    },
    require  => Package['consul'],
  }

  class { 'logstash':
    manage_repo  => true,
    repo_version => '1.4'
  }

}
