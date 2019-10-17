# -*- mode: ruby -*-
# vi: set ft=ruby :

$PROVISION_SCRIPT = <<-SCRIPT
export DEBIAN_FRONTEND=noninteractive

# Install docker
apt-get -yqq update
apt-get -yqq remove docker docker-engine docker.io containerd runc ||:
apt-get -yqq install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get -yqq update
apt-get -yqq install docker-ce docker-ce-cli containerd.io -y

# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
service docker restart

# Make sure we can actually use docker as the vagrant user
usermod -aG docker vagrant
docker --version

# Install docker-compose
echo "Installing docker-compose..."
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install development tools
echo "Installing development tools..."
apt-get -yqq install -y make pkg-config librdkafka-dev ntpdate jq

# Install golang
echo "Installing Go..."
VERSION=1.12.7
OS=linux
ARCH=amd64
curl -fsSL https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz | sudo tar -C /usr/local -xzf -

# Copy shell rc
echo "Copying rc files..."
[ -f /vagrant/bashrc ] && cp /vagrant/bashrc /home/vagrant/.bashrc

:
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian10"
  config.vm.hostname = ENV['USER'] + "-vm"

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.name = ENV['USER'] + "-buster"
  end
  config.vm.define :buster
  # Increase disk size
  config.disksize.size = '64GB'

  # Networking
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)",
                    :mac => "5CA1AB1E0002", use_dhcp_assigned_default_route: true
  # SSH
  config.ssh.forward_agent = true # So that boxes don't have to setup key-less ssh

  # Mount directories that we need in the VM
  config.vm.synced_folder ENV['HOME'] + "/Work", "/home/vagrant/Work"
  config.vm.synced_folder ENV['HOME'] + "/.config", "/home/vagrant/.config"
  config.vm.synced_folder ENV['HOME'] + "/.vagrant", "/home/vagrant/.vagrant"
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  # Provisioning script
  config.vm.provision "shell", inline: $PROVISION_SCRIPT
end
