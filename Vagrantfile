$script = <<SCRIPT
echo "Installing Docker..."
sudo apt-get update
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

# Install development tools
sudo apt-get install -y make

# Install golang
VERSION=1.12.7
OS=linux
ARCH=amd64
curl -fsSL https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz | sudo tar -C /usr/local -xzf -

# Add user
useradd -m -s /bin/bash chirag -u 502 -g 20 --groups sudo,docker
sudo chown 502:20 /home/chirag
su -c "printf 'cd /home/chirag\nexec sudo su - chirag' >> .bash_profile" -s /bin/sh vagrant
echo "%chirag ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/chirag
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/cosmic64"
  config.vm.hostname = "ckzed-vm"
  config.vm.provision "shell", inline: $script

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)",
                    use_dhcp_assigned_default_route: true

  # Mount Work directory
  config.vm.synced_folder "/Users/chirag", "/home/chirag"

end
