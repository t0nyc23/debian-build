#!/bin/bash
CRESET="\e[0m"
RED="\e[1;31m"
CYAN="\e[1;36m"
LOG_DIR="$HOME/Desktop/build"
LOG_OUT="$LOG_DIR/build.log"
LOG_ERR="$LOG_DIR/error.log"

FILES_DIR="$PWD/files"
CONFIG_DIR="$FILES_DIR/dot_config"

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