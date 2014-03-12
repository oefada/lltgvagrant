# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "chef/ubuntu-12.04"
    config.vm.hostname = "lldev"
    config.vm.network :private_network, ip: "10.11.12.30", netmask: "255.255.255.0"
    config.vm.network "forwarded_port", guest: 80, host: 80
    config.vm.network "forwarded_port", guest: 443, host: 443
    config.vm.synced_folder "../", "/vagrant", type: "nfs"
    config.vm.boot_timeout = 1200
    config.vm.provision :shell, :inline => "/vagrant/llvagrant/bootstrap.sh"
    
    config.vm.provider "parallels" do |parallels, override|
      override.vm.box = "parallels/ubuntu-12.04"
      override.vm.provision :shell, :inline => "/media/psf/vagrant/llvagrant/bootstrap.sh"
      parallels.memory = 2048
      parallels.cpus = 2
    end
    
    config.vm.provider "virtualbox" do |virtualbox|
      virtualbox.customize ["modifyvm", :id, "--memory", "2048"]
      virtualbox.customize ["modifyvm", :id, "--cpus", "2"]
      virtualbox.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    
    config.vm.provider "vmware_fusion" do |vmware_fusion|
      vmware_fusion.vmx["memsize"] = "2048"
      vmware_fusion.vmx["numvcpus"] = "2"
    end
end
