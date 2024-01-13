#!/bin/bash
source utils_and_vars.sh
source configure_desktop.sh
source install_basics.sh

#[INSTALL BASICS]
#-------------------------------------
basics_cmds=(
'configure_repos'
'install_basic_utils'
'install_nvidia_drivers'
'install_virtualbox'
'install_snap_tools'
'install_protonvpn'
'install_veracrypt'
'install_obsidian'
'install_discord_plus'
'install_brave'
'install_sublime'
)

print_header "Installing Software and Utilities."
for task in "${basics_cmds[@]}";do
	$task
	if [ $? -eq 0 ];then
		print_status "Finished with task: $task"
	fi
done

#[CONFIGURE DESKTOP]
#-------------------------------------
config_cmds=(
'import_panel_config'
'install_materia_theme'
'configure_wallpapper'
'configure_move2screen'
'configure_super_key'
'configure_lightdm'
'import_xfce_config'
'configure_bashrc'
)
print_header "Making Desktop Configurations."
for task in "${config_cmds[@]}";do
	$task
	if [ $? -eq 0 ];then
		print_status "Finished with task: $task"
	fi
done