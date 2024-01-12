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
	local themes_dir="$HOME/.themes"
	print_header "Installing Materia-Blackout theme."
	mkdir $themes_dir
	unzip $theme_file -d $themes_dir
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
		sudo chmod 644 $install_dir
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

configure_move2screen
configure_super_key
configure_wallpapper
install_materia_theme
import_panel_config
import_xfce_config









