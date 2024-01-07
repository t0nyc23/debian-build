#!/bin/bash
#
# This script automates repeated tasks when I create VPS server.
# Specifically, what it does is:
# 	- Create a non-root user
# 	- Disable the root account from ssh
# 	- Installs some basic tools and utilities
# 	- Installs and configures Fail2ban
# 	- Configures SSH with non-standard port, no password login (private auth)
# 	- Configures UFW to disallow the default ssh port and allow a custom one
# 	- Creates some config files for the new user
# 
# Keep in mind that the whole design is based for Debian (debian based will be ok, i guess)
# deployed from a Vultr instance with an uploaded Public SSH key.
#
# - non

CONFIG_DIR="$PWD/config_files"

install_tools() {	# STEP 1
        apt update
        apt -y install \
                tmux vim net-tools htop git \
		rsyslog fail2ban ufw whois \
		jq nmap wget curl
        echo -e "\n\n(+) Done."
}

create_user() {		# Step 2
	# Create a non-root user and disable root
        prompt_username="Enter a username: "
        read -p "$prompt_username" selected_username
        adduser $selected_username
        usermod -aG sudo $selected_username
	mkdir /home/$selected_username/.ssh
	mv ~/.ssh/authorized_keys /home/$selected_username/.ssh
	user_home=/home/$selected_username
	mv $CONFIG_DIR/tmux.conf $user_home/.tmux.conf
	mv $CONFIG_DIR/vimrc $user_home/.vimrc
	mv $CONFIG_DIR/bashrc $user_home/.bashrc
	chown -R $selected_username:$selected_username /home/$selected_username
	usermod -L root
        echo -e "\n\n(+) Done."
}

configure_srv() {	# STEP 3
	# UFW rules for non-default ssh port
	ufw allow 3223/tcp
	ufw delete allow 22/tcp
	
	# Configure SSH server
	mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
	cp $CONFIG_DIR/sshd_config /etc/ssh/sshd_config
	
	#Configure UFW support for fail2ban
	cp $CONFIG_DIR/ufw.aggressive.conf /etc/fail2ban/filter.d/ufw.aggressive.conf
	
	#Configure custom jail for fail2ban
	cp $CONFIG_DIR/jail.local /etc/fail2ban/jail.local
}

reload_services() {	# STEP 4
	systemctl reload sshd.service
	systemctl restart rsyslog.service
	systemctl restart fail2ban.service
}

echo "[+] Installing tools (misc.)"
install_tools
echo "[+] Configuring users"
create_user
echo "[+] Configuring SSH, FAIL2BAN, UFW"
configure_srv
echo "[+] Restarting Services"
reload_services
