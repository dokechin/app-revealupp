Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
#  config.vm.box_url = "http://vagrantcloud.com/ubuntu/boxes/trusty64"
  config.vm.synced_folder "./", "/vagrant", id: "vagrant-root"

  config.vm.provider "virtualbox" do |v|
  	v.cpus = 2
	v.memory = 2048
  end  

# config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :forwarded_port, guest:8000, host:3776

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.options = ['--verbose']
  end


end
