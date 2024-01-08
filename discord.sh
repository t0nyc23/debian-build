#!/bin/bash
CRESET="\e[0m"
RED="\e[1;31m"
CYAN="\e[1;36m"
APP="discord"

snap_or_flat () {
	snap list | grep $APP &> /dev/null
	if [ $? -eq 0 ]; then
		echo -e "\n\n${RED}[+] Discord is installed as a snap${CRESET}"
		echo -e "${RED}[+] Trying to uninstall first${CRESET}\n\n"
		sudo snap remove $APP
	fi
	flatpak list | grep $APP &> /dev/null
	if [ $? -eq 0 ]; then
		echo -e "\n\n${RED}[+] Discord is installed as a flatpak${CRESET}"
		echo -e "${RED}[+] Trying to uninstall first${CRESET}\n\n"
		flatpak uninstall -y discord
	fi
	echo -e "${CYAN}[+] Done${CRESET}\n\n"
}

discord_plus_deb () {
	echo -e "${CYAN}[+] Installing python3 requirements${CRESET}"
	sudo apt install python3-{requests,tk,bs4} -y
	dpkg -l | grep $APP &> /dev/null
	if [ $? -eq 0 ]; then
		echo -e "\n\n${RED}[+] Discord is installed${CRESET}"
		echo -e "${RED}[+] Trying to uninstall first${CRESET}\n\n"
		sudo apt -y remove $APP
	else
		snap_or_flat
	fi
}

discord_plus_fed () {
	echo -e "${CYAN}[+] Installing python3 requirements${CRESET}"
	sudo dnf install python3-{pip,requests,tkinter} -y
	pip3 install bs4

	dnf list | grep "^discord" &> /dev/null
	if [ $? -eq 0 ]; then
		echo -e "\n\n${RED}[+] Discord is installed${CRESET}"
		echo -e "${RED}[+] Trying to uninstall first${CRESET}\n\n"
		sudo dnf remove -y $APP
	else
		snap_or_flat
	fi	
}

#DISTRO=`grep "^ID_LIKE=" /etc/os-release | awk 'BEGIN {FS="="} {print $2}'`
echo -e "${CYAN}[+] Checking distro information${CRESET}"
which apt &> /dev/null
if [ $? -eq 0 ]; then
	echo -e "${CYAN}[+] Running debian based installation${CRESET}"
	discord_plus_deb
else
	echo -e "${CYAN}[+] Running fedora based installation${CRESET}"
	discord_plus_fed
fi

echo -e "${CYAN}[+] Creating symlink to /usr/local/bin/discord${CRESET}"       
sudo ln -sf $(pwd)/discord_plus.py /usr/local/bin/discord
echo -e "${CYAN}[+] Creating .desktop file${CRESET}"
desktop_file="[Desktop Entry]
Name=Discord
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
GenericName=Internet Messenger
Exec=/usr/local/bin/discord
Icon=$HOME/.local/share/Discord_plus/img/discord.png
Type=Application
Categories=Network;InstantMessaging;"
echo "$desktop_file" | sudo tee /usr/share/applications/discord.desktop > /dev/null
