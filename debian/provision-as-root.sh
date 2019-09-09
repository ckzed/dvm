#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

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
apt-get -yqq install -y make pkg-config librdkafka-dev ntpdate

# Install golang
echo "Installing Go..."
VERSION=1.12.7
OS=linux
ARCH=amd64
curl -fsSL https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz | sudo tar -C /usr/local -xzf -

# Install node?
apt-get install -yqq nodejs npm
npm install npm@latest -g

# Copy SSH keys
cp /vagrant/bashrc /home/vagrant/.bashrc
cp /vagrant/ssh/id_rsa* /home/vagrant/.ssh/
cp /vagrant/ssh/config /home/vagrant/.ssh/