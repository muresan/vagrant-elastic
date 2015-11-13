# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.ssh.pty = true

  hosts = {
    'el1' => { 'ip' => '192.168.123.101', 'cpus' => 1, 'memory' => 1024 },
    'el2' => { 'ip' => '192.168.123.102', 'cpus' => 1, 'memory' => 1024 },
    'el3' => { 'ip' => '192.168.123.103', 'cpus' => 1, 'memory' => 1024 }
  }

  hosts.each do |host, params|
    config.vm.define host, autostart: true do |host_config|
      host_config.vm.box = "dliappis/centos65minlibvirt"
      host_config.vm.hostname = "#{host}"
      host_config.vm.network :private_network, ip: params['ip']

      host_config.vm.provider :libvirt do |libvirt|
        libvirt.driver = 'kvm'
        libvirt.management_network_name = 'vagrant'
        libvirt.management_network_address = '192.168.123.0/24'
        libvirt.memory = params['memory']
        libvirt.cpus = params['cpus']
      end

      host_config.vm.provision :shell, inline: <<-SHELL
        sudo yum -y vim-enhanced
        sudo chkconfig iptables off
        sudo service iptables stop
        sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
        sudo yum -y install puppet
      SHELL

      host_config.vm.provision :puppet do |puppet|
        puppet.module_path = "modules"
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "default.pp"
      end
    end
  end
end
