$script = <<SCRIPT
echo "Installing Docker..."
sudo apt-get -q update
sudo apt-get -q remove docker docker-engine docker.io containerd runc
sudo apt-get -q install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get -q update
sudo apt-get -q install docker-ce docker-ce-cli containerd.io -y
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

# Install docker-compose
echo "Installing docker-compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install development tools
echo "Installing development tools..."
sudo apt-get -q install -y make pkg-config librdkafka-dev ntpdate

# Install golang
echo "Installing Go..."
VERSION=1.12.7
OS=linux
ARCH=amd64
curl -fsSL https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz | sudo tar -C /usr/local -xzf -

SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/cosmic64"
  config.vm.hostname = "ckzed-vm"
  config.vm.provision "shell", inline: $script

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end

  # Increase disk size
  config.disksize.size = '64GB'

  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)",
                    use_dhcp_assigned_default_route: true

  # SSH
  config.ssh.forward_agent = true # So that boxes don't have to setup key-less ssh
  # config.ssh.insert_key = false   # To generate a new ssh key and don't use the default Vagrant one

  # Mount Work directory
  config.vm.synced_folder "/Users/chirag/Work", "/workspace"
end
