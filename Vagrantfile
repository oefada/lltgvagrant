# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "lltg-dev-vm"
    config.vm.hostname = "lldev"
    config.vm.network :private_network, ip: "10.11.12.30", mac: "001C4270F501", netmask: "255.255.255.0"
    config.vm.synced_folder "../", "/vagrant"
    config.vm.boot_timeout = 1200
    
    config.vm.provider "parallels" do |parallels, override|
      override.vm.box = "parallels/ubuntu-12.04"
      override.vm.provision :shell, :inline => "/media/psf/vagrant/llvagrant/bootstrap.sh"
      parallels.memory = 2048
      parallels.cpus = 2
    end
    
    config.vm.provider "virtualbox" do |virtualbox, override|
      override.vm.box_url = 'https://s3.amazonaws.com/s3.luxurylink.com/vm/vagrant/virtualbox/lltg-dev-vm-virtualbox.box'
      override.vm.provision :shell, :inline => "/vagrant/llvagrant/bootstrap.sh"
      virtualbox.customize ["modifyvm", :id, "--memory", "2048"]
      virtualbox.customize ["modifyvm", :id, "--cpus", "2"]
      virtualbox.customize ["modifyvm", :id, "--ioapic", "on"]
    end
end
