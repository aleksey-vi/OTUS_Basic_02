Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_version = "2004.01"
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
   config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
     vb.cpus = 2
   end
   config.vm.provision "shell", path: "provision.sh"
end
