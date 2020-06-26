#!/bin/bash

# Create a Vagrantfile
cat > Vagrantfile << EOF
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.box_version = "1.0.282"

  config.vm.provider "virtualbox" do |v|
  v.memory = 2048
  v.cpus = 2
  end

  config.vm.network "forwarded_port", guest: 30000, host: 8080, auto_correct: true

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "k8s-playbook.yml"
  end
end
EOF

# Start the Vagrant box
vagrant up