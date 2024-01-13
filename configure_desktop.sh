#!/bin/bash

source utils_and_vars.sh

DEST_XFCE_CONF="$HOME/.config/xfce4"
SRC_XFCE_CONF="$CONFIG_DIR/xfce4/*"

import_xfce_config(){
	print_header "Importing XFCE4 Settings at $DEST_XFCE_CONF"
	cp -r $SRC_XFCE_CONF $DEST_XFCE_CONF
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to import XFCE4 settings."
	fi
}

install_materia_theme(){

	local theme_file="$FILES_DIR/Materia-Blackout.zip"
	#local themes_dir="$HOME/.themes"
	print_header "Installing Materia-Blackout theme."
	#mkdir $themes_dir
	sudo unzip $theme_file -d /usr/share/themes
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to install Materia-Blackout theme."
	fi
}

import_panel_config(){
	local panel_config="$FILES_DIR/non-custom-panel.tar.bz2"
	print_header "Importing Custom Panel Configuration"
	xfce4-panel-profiles load $panel_config
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to import custom panel Configuration"
	fi
}

configure_move2screen(){
	local script_file="$FILES_DIR/move2screen"
	local install_dir="/usr/local/bin/move2screen"
	print_header "Configuring move2screen"
	sudo cp $script_file $install_dir
	if [ $? -eq 0 ];then
		sudo chown root:root $install_dir
		sudo chmod 755 $install_dir
		print_status "Done"
	else
		print_error "Failed to configure move2screen"
	fi
}

configure_super_key(){
	local autostart_dir="$CONFIG_DIR/autostart"
	print_header "Configuring Super Key to open Menu"
	cp -r $autostart_dir "$HOME/.config"
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to configure super key menu"
	fi
}

configure_wallpapper(){
	local zip_file="$FILES_DIR/backgrounds.zip"
	local dest_path="$HOME/.local/share/"
	print_header "Configuring Desktop Wallpappers"
	unzip $zip_file -d $dest_path
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to configure Wallpappers"
	fi
}

configure_lightdm(){
	local background_image="$HOME/.local/share/backgrounds/ellcyan.jpg"
	local config_file="$FILES_DIR/lightdm-gtk-greeter.conf"
	print_status "Configuring LightDM"
	sudo cp $background_image /usr/share/backgrounds/
	sudo cp $config_file /etc/lightdm/
	sudo chown root:root /etc/lightdm/lightdm-gtk-greeter.conf
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to configure LightDM"
	fi	
}

configure_bashrc(){
	local bashrc_file="$FILES_DIR/BASHRC"
	print_header "Configuring .bashrc"
	cp $bashrc_file $HOME/.bashrc
}

configure_tmux(){
	local tmux_file="$FILES_DIR/TMUX_CONF"
	print_header "Configuring .tmux.conf"
	cp $tmux_file $HOME/.tmux.conf
}

configure_sublime(){
	local config_dir="$CONFIG_DIR/sublime-text/*"
	local dest="$HOME/.config/sublime-text/"
	print_header "Configuring Sublime Text"
	mkdir -p $dest
	cp -r $config_dir $dest
	if [ $? -eq 0 ];then
		print_status "All ok"
	else
		print_error "Failed to configure LightDM"
	fi	
}