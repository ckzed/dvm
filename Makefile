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

.PHONY: halt
halt:
	vagrant halt

.PHONY: clean
clean:
	vagrant destroy --force
