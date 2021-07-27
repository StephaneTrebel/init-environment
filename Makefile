# Target directory to install all the configuration to.
TARGET := ${HOME}

.PHONY: help
help: ## Display this help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-15s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: docker-ce
docker-ce: ## Install docker Community Edition
	sudo apt update
	sudo apt remove docker docker-engine docker.io containerd runc
	sudo apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
	sudo apt update
	sudo apt install docker-ce docker-ce-cli containerd.io

.PHONY: dependencies
dependencies: ## Install base dependencies
	sudo apt update
	sudo apt install -y \
		stow \
		flameshot \
		ack wget evince

.PHONY: install_gnucash
install_gnucash: ## Install gnucash 3.8
	sudo add-apt-repository ppa:sicklylife/gnucash3.8
	sudo apt update
	sudo apt install -y gnucash

.PHONY: terminal
terminal: ## Install terminal dependencies
	sudo apt update
	sudo apt install -y \
		konsole fonts-firacode

.PHONY: all
all:
