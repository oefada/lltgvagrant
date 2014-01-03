# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "lldev-base"
    config.vm.hostname = "lldev"
    config.vm.synced_folder "../", "/vagrant"
    config.vm.provision :shell, :inline => "/media/psf/vagrant/llvagrant/bootstrap.sh"
    
    config.vm.provider "parallels" do |parallels|
      parallels.name = "LLTG Dev VM"
      parallels.customize ["set", :id, "--memsize", "2048"]
      parallels.customize ["set", :id, "--cpus", "2"]
    end
end