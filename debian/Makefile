.PHONY: package recreate

package:
	vagrant halt && \
	vagrant destroy --force && \
	vagrant box update --force && \
	vagrant up --provision && \
	vagrant package --base ckzed-buster --output ckzed-buster.box && \
	vagrant box add ckzed-buster ckzed-buster.box && \
	cp .vagrant/machines/buster/virtualbox/private_key $HOME/.ssh/ckzed-buster.pem && \
	vagrant halt && \
	vagrant destroy --force

recreate:
	vagrant halt && \
	vagrant destroy --force && \
	vagrant box update --force && \
	vagrant up --provision && \
	vagrant ssh
