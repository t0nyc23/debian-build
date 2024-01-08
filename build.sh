#!/bin/bash

CRESET="\e[0m"
RED="\e[1;31m"
CYAN="\e[1;36m"

print_status(){
	local message=$1
	echo -e "${CYAN}[+] $message${CRESET}"
}

print_header(){
	local message=$1
	echo -e "${CYAN}"
	echo -e "=============================================================="
	echo -e "[+] $message"
	echo -e "=============================================================="
	echo -e "${CRESET}"
}

print_error(){
	local message=$1
	echo -e "${RED}"
	echo -e "=============================================================="
	echo -e "[!] $message"
	echo -e "=============================================================="
	echo -e "${CRESET}"
}

install_basic_utils(){
	print_header "Basic Software and Utilities."
	sudo apt update && sudo apt -y install \
		tmux vim net-tools htop git \
		wget curl xcape vlc terminator \
		flameshot cherrytree gparted gdebi \
		snapd peek piper dnsutils \
		xdotool wmctrl linux-headers-amd64
	print_status "Done installing basic utilities/software."
}

install_virtualbox(){
	local vboxasc="https://www.virtualbox.org/download/oracle_vbox_2016.asc"
	local vboxascout="/usr/share/keyrings/oracle-virtualbox-2016.gpg"
	local vboxexturl="https://download.virtualbox.org/virtualbox/7.0.12/Oracle_VM_VirtualBox_Extension_Pack-7.0.12.vbox-extpack"
	local vboxext=`echo $vboxexturl | awk -F '/' '{print $6}'`
	print_header "VirtualBox and VirtualBox Extension Pack."
	print_status "Importing GPG keys from ${vboxasc}"
	wget -O- -q $vboxasc | sudo gpg --dearmor -o $vboxascout
	if [ $? -eq 0 ]; then
		print_status "Adding VirtualBox Repository."
		echo "deb [arch=amd64 signed-by=${vboxascout}] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | \
			sudo tee /etc/apt/sources.list.d/virtualbox.list
		if [ $? -eq 0 ]; then
			print_status "Installing VirtualBox."
			sudo apt update && sudo apt -y install virtualbox-7.0
			if [ $? -eq 0 ]; then
				print_status "Adding $USER to vboxusers"
				sudo usermod -aG vboxusers $USER
				print_status "Donwloading extension pack from ${vboxexturl}"
				wget -q $vboxexturl
				sudo vboxmanage extpack install $vboxext
			fi
		fi
	fi
	rm $vboxext
	print_status "Done Installing VirtualBox and VirtualBox Extension Pack."
}

configure_repos(){
	print_header "Configuring Debian Repositories."
	sudo mv /etc/apt/sources.list /etc/apt/sources.list_old
	local sources_list="
		\rdeb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware\n
		\rdeb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware\n
		\rdeb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware\n
		\rdeb-src http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware\n
		\rdeb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware\n
		\rdeb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware"
	echo -e $sources_list | sudo tee /etc/apt/sources.list
	print_status "Finished Configuring Debian Repositories."
}

install_nvidia_drivers(){
	print_header "Installing Nvidia Graphics Drivers."
	sudo apt update && sudo apt -y install \
		nvidia-driver firmware-misc-nonfree
	if [ $? -eq 0 ]; then
		print_status "Finished Installing Nvidia Graphics Drivers."
	else
		print_error "Something went wrong. Nvidia Drivers not installed!"
	fi 
		
}
# STEP 1
#configure_repos
# STEP 2
#install_basic_utils
# STEP 3
#install_nvidia_drivers
# STEP 4
#install_virtualbox
