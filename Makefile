.PHONY: all
all: update reload ssh

.PHONY: ssh reload up halt
ssh reload up halt:
	vagrant $@

.PHONY: update
update:
	vagrant box $@

.PHONY: clean
clean:
	vagrant destroy --force
