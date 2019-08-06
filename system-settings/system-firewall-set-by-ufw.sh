#!/bin/bash

# -------------------------------------
# common functions
# -------------------------------------

# check package manager
# return: apt or yum
function get_package_manager
{
	local package_manager=apt
    if [ -x "$(command -v yum)" ]; then
        package_manager=yum	
    fi
	# return
	echo "$package_manager"
}



# -------------------------------------
# my functions
# -------------------------------------

function install_ufw
{
	# call
	package_manager=$(get_package_manager)
	echo -e "\n\n Package manager is $package_manager ! \n\n"

	echo -e "\n\n Install ufw ... \n\n"
	sudo $package_manager install -y ufw
	echo -e "\n\n Install ufw is successful ! .. \n\n"
	ufw status # inactive
}

function config_ufw
{
	echo -e "\n\n Config ufw ... \n\n"
	# Flush the tables to apply changes
	iptables -F
	# reset rules
	ufw reset
	# set default
	ufw default deny incoming
	ufw default allow outgoing
	# add allow
	ufw allow OpenSSH
	ufw allow http
	ufw allow https
	# enable ufw
	ufw enable
	ufw status # active
	echo -e "\n\n Config ufw is successful ! ... \n\n"
}

function restart_sys
{
	echo -n "ufw need restart system. Restart now?(yes/no) "
	read op_code
	while true; do
		if [ "$op_code" = "yes" ]; then
			reboot
			break
		fi
		if [ "$op_code" = "no" ]; then
			break
		fi
		echo -n "Please input yes or no. Restart now?(yes/no) "
		read op_code
	doen
}
# -------------------------------------
# main
# -------------------------------------


# 1. install ufw
install_ufw

# 2. config ufw (need restart system)
config_ufw

# ENDING
echo -e "\n\n All is done! \n\n"
echo -e "--------------------------------------------------------"
echo -e "View ufw status: sudo ufw status"
echo -e "--------------------------------------------------------\n\n"


# restart system make it work
restart_sys