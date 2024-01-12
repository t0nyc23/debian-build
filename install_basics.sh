#!/bin/bash
#configure_repos
#install_basic_utils
#install_nvidia_drivers
#install_virtualbox
#install_snap_tools
#install_protonvpn
#install_veracrypt
#install_obsidian
#install_discord_plus
#install_brave
#install_sublime

source utils_and_vars.sh

install_snap_tools(){
	print_header "Snap packages auto-cpufreq and Video-Downloader"
	sudo apt update && sudo apt -y install snapd
	if [ $? -eq 0 ];then
		sudo snap install core
		sudo snap install video-downloader
		sudo snap install auto-cpufreq
	else
		print_error "Failed to install either snapd"
	fi
	print_status "Finished Setting Up Snap software."
}

install_basic_utils(){
	print_header "Basic Software and Utilities."
	sudo apt update && sudo apt -y install \
		tmux vim net-tools htop git \
		wget curl xcape vlc terminator \
		flameshot cherrytree gparted gdebi \
		peek piper dnsutils \
		xdotool wmctrl linux-headers-amd64 \
		xfce4-panel-profiles gnome-colors zip
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

install_protonvpn(){
	print_header "Proton VPN Setup (CLI)"
	local pvpnurl="https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3_all.deb"
	local pvpndeb=`echo $pvpnurl | awk -F '/' '{print $9}'`
	print_status "Installing ${pvpndeb}"
	wget -q $pvpnurl && sudo gdebi -n $pvpndeb
	print_status "Installing protonvpn-cli"
	sudo apt update && sudo apt -y install protonvpn-cli
	rm $pvpndeb
	print_status "Finished setup for Proton VPN"
}

install_veracrypt(){
	#Add the following to Default mount parameters (mount options):
	#	fmask=133,dmask=022
	print_header "Setting Up Veracrypt"
	local vcurl="https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-12-amd64.deb"
	local vcdeb=`echo $vcurl | awk -F '/' '{print $8}'`
	print_status "Installing $vcdeb"
	wget -q $vcurl && sudo gdebi -n $vcdeb
	print_status "Finished installing Veracrypt"
	rm $vcdeb
}

install_obsidian(){
	print_header "Obsidian Installation"
	local oburl="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/obsidian_1.5.3_amd64.deb"
	local obdeb=`echo $oburl | awk -F '/' '{print $9}'`
	print_status "Downloading and installing Obsidian"
	wget -q $oburl && sudo gdebi -n $obdeb
	print_status "Finished installing Obsidian"
	rm $obdeb
}

install_discord_plus(){
	print_header "Setting Up Discord_plus"
	local giturl="https://github.com/t0nyc23/discord_plus"
	local cloned=$HOME/.local/share/Discord_plus
	print_status "Cloning Repository"
	git clone $giturl $cloned
	print_status "Running install script"
	cd $cloned && bash install.sh && cd -
	print_status "Discord_plus is now installed"
}

install_brave(){
	print_header "Setting Up Brave Browser"
	local brgpg="/usr/share/keyrings/brave-browser-archive-keyring.gpg"
	local brurl="https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
	print_status "Import GPG from ${brurl}"
	sudo curl -fsSLo $brgpg $brurl
	print_status "Adding Brave Browser's repo."
	echo "deb [signed-by=${brgpg}] https://brave-browser-apt-release.s3.brave.com/ stable main"| \
		sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	print_status "Installing Brave Browser"
	sudo apt update && sudo apt -y install brave-browser
	print_status "Brave is now installed"
}

install_sublime(){
	print_header "Setting Up Sublime Text"
	local suburl="https://download.sublimetext.com/sublimehq-pub.gpg"
	print_status "Importing GPG from $suburl"
	wget -qO - $suburl | gpg --dearmor | sudo tee \
		/etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
	print_status "Adding Sublime's Repository"
	echo "deb https://download.sublimetext.com/ apt/stable/" | \
		sudo tee /etc/apt/sources.list.d/sublime-text.list
	print_status "Installing Sublime Text"
	sudo apt update && sudo apt -y install sublime-text
	print_status "Sublime-Text is now installed."
}