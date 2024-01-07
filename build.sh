#!/bin/bash

CRESET="\e[0m"
RED="\e[1;31m"
CYAN="\e[1;36m"

print_status(){
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
	print_status "[+] Installing basic utilities/software."
	sudo apt update && sudo apt -y install \
		tmux vim net-tools htop git \
		wget curl xcape vlc terminator \
		flameshot cherrytree gparted gdebi \
		snapd peek piper dnsutils
	print_status "[+] Done."
}

install_nvidia_drivers(){
	print_status "[+] Installing Nvidia Drivers."
}

print_status "Test"
print_error "Test"