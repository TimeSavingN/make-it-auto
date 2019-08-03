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

# Check Tools Exist
# return: true or false
function check_tool_exist
{
	local is_exist=false
	if [ -x "$(command -v $1)" ]; then
		is_exist=true
	fi
	echo "$is_exist"
}

# -------------------------------------
# my functions
# -------------------------------------

# remove old versions
function remove_exist_docker
{
	if [ "$package_manager" = yum ]; then
		sudo yum remove docker \
				  docker-client \
				  docker-client-latest \
				  docker-common \
				  docker-latest \
				  docker-latest-logrotate \
				  docker-logrotate \
				  docker-engine
	fi
	if [ "$package_manager" = apt ]; then 
		sudo apt-get remove docker docker-engine docker.io containerd runc
	fi
}

# install docker from repo
function install_docker_from_repo
{
	if [ "$package_manager" = yum ]; then
		# SET UP THE REPOSITORY
		sudo yum install -y yum-utils \
			device-mapper-persistent-data \
			lvm2
		sudo yum-config-manager \
			--add-repo \
			https://download.docker.com/linux/centos/docker-ce.repo
			
		# INSTALL DOCKER ENGINE - COMMUNITY
		sudo yum install docker-ce docker-ce-cli containerd.io
	fi
	
	if [ "$package_manager" = apt ]; then
		# SET UP THE REPOSITORY
		sudo apt-get update
		sudo apt-get install \
			apt-transport-https \
			ca-certificates \
			curl \
			gnupg2 \
			software-properties-common
		curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
		sudo apt-key fingerprint 0EBFCD88
		# INSTALL DOCKER ENGINE - COMMUNITY
		sudo apt-get update
		sudo apt-get install docker-ce docker-ce-cli containerd.io
	fi
}


# -------------------------------------
# main
# -------------------------------------



# check package manager
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"

# install
if [ "$is_exist" = true ]; then
	echo -e "\n\n $tool_name tool is exist ! \n\n"
	read "$(docker --version) is installed. Do you want to reinstaled it? (yes/no)" operation_code
	while true; do
		if [ "${operation_code}" = yes ]; then
		
			remove_exist_docker
			echo -e "\n\n Docker remove is successful ! \n\n"
			
			install_docker_from_repo
			echo -e "\n\n docker installation is successful ! \n\n"
		
			break
		fi
		fi ["${operation_code}" = no ]; then
			break
		fi
		read "$(docker --version) is installed. Do you want to reinstaled it? (yes/no)" operation_code
	done
else
	install_docker_from_repo
	echo -e "\n\n docker installation is successful ! \n\n"
fi 

# END
echo -e "\n start docker: sudo systemctl start docker \n"
echo -e "\n Verify that Docker Engine: sudo docker run hello-world \n"

