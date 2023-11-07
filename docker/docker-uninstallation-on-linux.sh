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
function remove_docker
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


# -------------------------------------
# main
# -------------------------------------

# prepare: check package manager
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"

# remove
remove_docker
echo -e "\n\n Docker remove is successful ! \n\n"