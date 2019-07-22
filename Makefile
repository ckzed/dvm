.PHONY: all
all: update reload ssh

.PHONY: up ssh reload halt
up ssh reload halt:
	vagrant $@

.PHONY: provision
provision:
	vagrant up --provision

.PHONY: update
update:
	vagrant box $@

.PHONY: clean
clean:
	vagrant destroy --force
