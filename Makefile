.PHONY: all
all: reload ssh

.PHONY: ssh
ssh:
	vagrant ssh

.PHONY: up
up:
	vagrant up

.PHONY: reload
reload:
	vagrant reload

.PHONY: clean
clean:
	vagrant destroy --force
