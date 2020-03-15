# Target directory to install all the configuration to.
TARGET := ${HOME}

.PHONY: help
## Show help
help:
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: apt-update
apt-update:
	sudo apt update

.PHONY: apt-upgrade
apt-upgrade:
	sudo apt upgrade

.PHONY: docker
docker: apt-update apt-upgrade ## Install docker Community Edition
	sudo apt remove docker docker-engine docker.io containerd runc
	sudo apt install \
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
dependencies: apt-update apt-upgrade ## Install base dependencies
	sudo apt install \
		# Web browsers
		chromium-browser firefox \
		# dotfiles management
		stow \
		# Build utilities for third-party dependencies
	  build-essential cmake python-dev python3-dev \
		# Miscellaneous utilities
		ack tmux wget evince

.PHONY: shell-configuration
shell-configuration: ## Add all my custom shell configuration
	sudo apt install \
	  # The one and only
		vim vim-gtk \
		# Terminal and the font that will be used with it
		konsole fonts-firacode

.PHONY: vim-ide
vim-ide: dependencies ## Install vim and all my vim configuration
	sudo apt install \
	  # The one and only
		vim vim-gtk \
		# Terminal and the font that will be used with it
		konsole fonts-firacode

.PHONY: install-vim-custom-configuration
install-vim-custom-configuration:
	# Add vim configuration as a symbolic link to the submodules directory
	stow -d submodules -t $${TARGET} vim
	# Launch vim with the plugin install command and quit immediately
	vim -c "PluginInstall | q"

.PHONY: compile-youcompleteme-binaries
compile-youcompleteme-binaries: install-vim-custom-configuration
	cd submodules/vim/.vim/bundle/YouCompleteMe && \
	python3 ./install.py




.PHONY: all
all: dependencies vim-ide docker gnucash
