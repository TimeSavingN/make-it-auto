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
		if [ "$package_manager" = "apt" ]; then
			sudo apt-get install ufw -y
		fi
		if [ "$package_manager" = "yum" ]; then
			# By default, UFW is not available in CentOS repository. So you will need to install the EPEL repository to your system. 
			sudo yum install epel-release -y
			# install UFW
			sudo yum install --enablerepo="epel" ufw -y
		fi
		echo -e "\n\n Install ufw is successful ! .. \n\n"
		
		
		# enable UFW firewall
		sudo ufw enable 
		
		# check the status of UFW
		sudo ufw status # inactive

		# enable ufw service automatically on boot
		sudo systemctl enable ufw

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
	# view ufw enable ip and port status
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
	
	# enable ufw firewall
	sudo ufw enable

	# view ufw enable ip and port status
	sudo ufw status 

	echo -e "\n\n Config ufw is successful ! ... \n\n"
	echo -e "\nufw open 22/tcp, 80/tcp, 443/tcp.\n"
	
	# disable firewalld on CentOS/RHEL
	package_manager=$(get_package_manager)
	if [ "$package_manager" = "yum" ]; then
		echo -e "\n\n disable firewalld on CentOS/RHEL \n\n"
		sudo systemctl disable firewalld.service
		
		# The following command will lose current ssh session, and make ssh connect fail.
		# Using service disable and OS restart is enough 
		# sudo service firewalld stop
		
		sudo service firewalld status
		
		echo -e "\n\n disable firewalld is successful ! \n\n"
	fi
	
	
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
