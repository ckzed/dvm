#!/bin/sh

set -e

export DEBIAN_FRONTEND=noninteractive
export DC_VERSION=1.25.4
export GO_VERSION=1.12

# Install docker
apt-get -yqq update
apt-get -yqq remove docker docker-engine docker.io containerd runc ||:
apt-get -yqq install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

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
curl -L "https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install development tools
echo "Installing development tools..."
apt-get -yqq install -y make pkg-config librdkafka-dev ntpdate jq python3-pip

# Install golang
echo "Installing Go..."

OS=linux
ARCH=amd64
curl -fsSL https://dl.google.com/go/go${GO_VERSION}.${OS}-${ARCH}.tar.gz | sudo tar -C /usr/local -xzf -

# # Install node?
# apt-get install -yqq nodejs npm
# npm install npm@latest -g

# Install zsh
echo "Installing zsh..."
apt-get -yqq install -y zsh
cd /home/vagrant/
sudo -u vagrant HOME=/home/vagrant sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh vagrant

# Copy shell rc
echo "Copying rc files..."
[ -f /vagrant/bashrc ] && cp /vagrant/bashrc /home/vagrant/.bashrc
[ -f /vagrant/zshrc ] && cp /vagrant/zshrc /home/vagrant/.zshrc
[ -f /vagrant/ckzed.zsh-theme ] && cp /vagrant/ckzed.zsh-theme /home/vagrant/.oh-my-zsh/themes/

# Copy SSH keys
echo "Copying SSH files..."
cp /vagrant/ssh/id_rsa* /home/vagrant/.ssh/
cp /vagrant/ssh/config /home/vagrant/.ssh/

# Docker helper aliases
echo "Copying docker aliases files..."
[ -f /vagrant/docker-aliases ] && cp /vagrant/docker-aliases /home/vagrant/.docker-aliases

echo "All done!"
