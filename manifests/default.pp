
## ES nodes

node /^es\d+/ {
  package { "vim-enhanced": ensure => 'installed', }
  package { "git"         : ensure => 'installed', }
  package { "acpid"       : ensure => 'installed', }


  class { 'elasticsearch': 
    config => { 'cluster.name' => 'es-cluster' }
  }

  elasticsearch::instance { $::hostname:
    datadir => "/var/lib/es-data-${::hostname}",
  }
}


