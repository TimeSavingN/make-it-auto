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

	if [ -x "$(command -v ufw)" ]; then
		echo -e "\n\n ufw is alredy installed ! \n\n"
	else
		echo -e "\n\n Install ufw ... \n\n"
		sudo $package_manager install -y ufw
		echo -e "\n\n Install ufw is successful ! .. \n\n"
		sudo ufw status # inactive
	fi
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
	done
}


function config_ufw
{	
	sudo ufw status
	echo -e "\n\n Config ufw ... \n\n"
	# Flush the tables to apply changes
	sudo iptables -F
	# reset rules
	sudo ufw reset
	# set default
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	# add allow
	sudo ufw allow 22/tcp
	sudo ufw allow 80/tcp
	sudo ufw allow 443/tcp
	# enable ufw
	sudo ufw enable
	echo -e "\n\n Config ufw is successful ! ... \n\n"
	sudo ufw status # active
	
	# disable firewalld on CentOS/RHEL
	package_manager=$(get_package_manager)
	if [ "$package_manager" = "yum" ]; then
		echo -e "\n\n disable firewalld on CentOS/RHEL \n\n"
		sudo service firewalld stop
		sudo systemctl disable firewalld.service
		sudo service firewalld status
		echo -e "\n\n disable firewalld is successful ! \n\n"
	fi
	
	# enable ufw automatically on boot
	sudo systemctl enable ufw
	
	# restart system make ufw rules work
	restart_sys
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
