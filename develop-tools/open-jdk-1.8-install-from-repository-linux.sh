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

# Get Valid Answer From Terminal
# return: $answer
function get_valid_answer
{
	message="$1 (yes/no): "
	echo -n "$message"
	read answer
	while true; do
		if [ "$answer" = "yes" ] || [ "$answer" = "no" ]; then
			break;
		else
			echo -n $message
			read answer
		fi
	done
}

# Get number of range from Terminal Input
# return $answer_num
function get_number_of_range
{
	min=$2
	max=$3
    message="$1. Input ($min~$max): "
	echo -n "$message"
	read answer_num
	while true; do
		if [ "$answer_num" -ge "$min" ] && [ "$answer_num" -le "$max" ]; then
			break;
		else
			echo -n $message
			read answer_num
		fi
	done
}



# -------------------------------------
# my functions
# -------------------------------------

function install_jdk_default
{
	# yum
	if [ "$package_manager" = "yum" ]; then
		# 1. Search OpenJDK Packages
		# yum search java | grep 'java-'
		
		# 2. install java
		echo -e "\n\n Install JDK 1.8 ... \n\n"
		sudo yum install -y java-1.8.0-openjdk.x86_64
		echo -e "\n\n Install JDK 1.8 is successful ! \n\n"
	fi

	# apt
	if [ "$package_manager" = "apt" ]; then
		# 1. Search OpenJDK Packages
		# apt-cache search openjdk
		
		# 2. install java (OpenJDK)
		echo -e "\n\n Install JDK 1.8 ... \n\n"
		sudo apt-get install -y openjdk-8-jre openjdk-8-jdk
		echo -e "\n\n Install JDK 1.8 is successful ! \n\n"
	fi
}

function install_jdk_selected
{
	if [ "$package_manager" = "apt" ]; then
		mapfile -t jdk_array < <( sudo apt-cache search openjdk | grep -E '^openjdk-[0-9]{1,2}-jdk' )
		sudo apt-cache search openjdk | grep -E '^openjdk-[0-9]{1,2}-jdk' | cat -b
	fi
	if [ "$package_manager" = "yum" ]; then
		mapfile -t jdk_array < <( sudo yum search java- | grep -E 'java.+openjdk\.' )
		sudo yum search java- | grep -E 'java.+openjdk\.' | cat -b
	fi
	
	arr_len="${#jdk_array[@]}"
	get_number_of_range "Please select your install version." 1 $arr_len
	sudo $package_manager install ${jdk_array[answer_num]}
}

function configure_jdk
{
	# yum
	if [ "$package_manager" = "yum" ]; then
		# 3. Configure Default Java Version
		java -version
		
		# 4. Set JAVA_HOME 
		echo "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-0.el7_6.x86_64/" >> /etc/environment
		source /etc/environment
		echo -e "\n\n Your JAVA_HOME is $JAVA_HOME \n\n"
		echo -e "\n\n install JDK 1.8 is successful ! \n\n"
	fi
	
	# apt
	if [ "$package_manager" = "apt" ]; then
		
		# 3. Configure Default Java Version
		java -version
		
		# 4. Set JAVA_HOME
		echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /etc/environment
		source /etc/environment
		echo -e "\n\n Your JAVA_HOME is $JAVA_HOME \n\n"
		echo -e "\n\n install JDK 1.8 is successful ! \n\n"
	fi
}

# -------------------------------------
# main
# -------------------------------------

# Check package manager
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"

# check is installed
if ! [ -x "$(command -v java)" ]; then
	question="Does install default java-1.8-x64?"
	get_valid_answer "$question"
	if [ "$answer" = "yes" ]; then
		install_jdk_default
	else
		install_jdk_selected
	fi
	
	configure_jdk
else
	echo -e "\n\n You already install java! \n\n"
	java -version
fi


# ENDING
echo -e "\n\n All is done! \n\n"

