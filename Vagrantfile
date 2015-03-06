# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box      = "centos7"
  config.vm.box_url     = "https://www.dropbox.com/s/qtw8hc4k7o9x8cp/centos7.box?dl=1"
  config.vm.network   "forwarded_port", guest: 3000, host: 3000

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    # following configs resolve a bug causing bundle gem to hang 5 seconds per get
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  config.vm.provision "shell",
    inline: 'sudo yum update -y; sudo yum install sqlite-devel openssl-devel ruby-devel rubygem-devel rubygem-bundler mariadb-devel java-1.7.0-openjdk-devel nodejs -y; sudo yum groupinstall "Development Tools" sudo iptables -I INPUT -j ACCEPT; sudo service iptables save'
end
