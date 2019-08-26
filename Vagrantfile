$script = <<SCRIPT

echo "Vagrant provisioning running as ${UID}:${GID}"

echo "Installing Docker..."
apt-get -q update
apt-get -q remove docker docker-engine docker.io containerd runc
apt-get -q install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
apt-get -q update
apt-get -q install docker-ce docker-ce-cli containerd.io -y
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
apt-get -q install -y make pkg-config librdkafka-dev ntpdate

# Install golang
echo "Installing Go..."
VERSION=1.12.7
OS=linux
ARCH=amd64
curl -fsSL https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz | sudo tar -C /usr/local -xzf -

# Install pip3 and modules
echo "Installing pip3..."
apt-get install -y python3-pip
pip3 install tensorflow scikit-learn

# Install linuxkit
PATH=/usr/local/go/bin:$PATH
GOPATH=/usr/local/go
echo "Installing linuxkit"
go get -u github.com/linuxkit/linuxkit/src/cmd/linuxkit

# Install goreleaser
mkdir -p /build
cd /build
if [ -d goreleaser ]; then
   cd goreleaser && git pull
else
   git clone https://github.com/goreleaser/goreleaser
   cd goreleaser
fi

# get dependencies using go modules (needs go 1.11+)
go get ./...

# build
go build -o goreleaser .

# check it works
./goreleaser --version

# Setup sudo
# echo vagrant ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant

# Copy SSH keys
cp /vagrant/.bashrc-vagrant /home/vagrant/.bashrc
cp /vagrant/.ssh/id_rsa* /home/vagrant/.ssh/
cp /vagrant/.ssh/config /home/vagrant/.ssh/

SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/cosmic64"
  config.vm.hostname = "ckzed-vm"
  config.vm.provision "shell", inline: $script

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "6144"
  end

  # Increase disk size
  config.disksize.size = '64GB'

  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)",
                    :mac => "5CA1AB1E0001", use_dhcp_assigned_default_route: true

  # SSH
  config.ssh.forward_agent = true # So that boxes don't have to setup key-less ssh
  # config.ssh.insert_key = false   # To generate a new ssh key and don't use the default Vagrant one

  # Mount directories that we need in the VM
  config.vm.synced_folder "/Users/chirag/Work", "/home/vagrant/Work"
  config.vm.synced_folder "/Users/chirag/Research", "/home/vagrant/Research"
  config.vm.synced_folder "/Users/chirag/.config", "/home/vagrant/.config"
  config.vm.synced_folder "/Users/chirag/.vagrant", "/home/vagrant/.vagrant"
end
