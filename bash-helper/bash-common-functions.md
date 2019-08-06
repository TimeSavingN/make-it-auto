# Bash Common Functions

### Content

- Check
  - 1.1 Get Package Manager Name
  - 1.2 Get Host Location
  - 1.3 Check Tools Exist
  - 1.4 Check Service Is Installed
- Operation
  - Backup File Path
  - Apt Update
- System Settings
  - Set sources.list
  - Set Time Zone
- Config
  - Config vim



### Main

### 1.1 Get Package Manager Name

```shell
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

# call
package_manager=$(get_package_manager)
echo -e "\n\n Package manager is $package_manager ! \n\n"
```

### 1.2 Get Host Location

```shell
server_location='inland'
ping -c 1 -w 5 google.com
if [ $? -eq 0 ]; then 
	server_location='abroad'
fi
```

### 1.3 Check Tools Exist

```shell
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

# call
tool_name=<tool_name>
if ! [ "$(check_tool_exist $tool_name)" = true ]; then
	echo -e "\n\n $tool_name tool is not exist ! \n\n"
fi 
```



### 1.4 Check Service Is Installed

```shell
# Check Service Is Installed
# return: true or false
function check_service_is_installed
{
	local is_installed=false
	if [ -n "$(systemctl | grep $1)" ]; then
		is_installed=true
	fi
	echo "$is_installed"
}

# call
service_name=<service_name>
if ! [ "$(check_service_is_installed $service_name)" = true ]; then
	echo -e "\n\n $service_name service is not installed ! \n\n"
fi 
```



### Operations



### 2.1 Backup File Path

```shell
# Backup File Path
function backup_filepath
{
	bak_path="$1.bak"  #/etc/apt/sources.list.bak
    i=1
    while true; do
        if ! [ -f $bak_path ]; then
            break
        fi
        bak_path="${bak_path}.$i"
        i=$[$i + 1]
    done
    sudo cp $1 $bak_path
}

# call
backup_filepath /etc/apt/sources.list
```

### 2.2 Apt Update

```shell
# apt update
# import get_package_manager()
function apt_update
{
	echo -e "\n\n apt update... \n\n"
    if [ "$package_manager" = "yum" ]; then
        sudo yum update -y && yum upgrade && yum autoremove
    fi
    if [ "$package_manager" = "apt" ]; then
        sudo apt update && apt upgrade -y && apt autoremove && apt autoclean
    fi
    echo -e "\n\n apt update is finished ! \n\n"
}

# call
apt_update
```





### System Settings

### 3.1 Set sources.list

```shell
# Set sources.list
# import backup_filepath()
function set_sources_list
{
    server_location='inland'
    ping -c 1 -w 5 google.com
    if [ $? -eq 0 ]; then 
        server_location='abroad'
    fi
    echo -e "\n\n Server location is $server_location ! \n\n"
    source_path=/etc/apt/sources.list
	if [ "$server_location" = "inland" ]; then
		if [ -f $source_path ]; then
			if ! [[ -n $(sudo grep "http://mirrors.aliyun.com/ubuntu/" $source_path) ]]; then 
				backup_filepath $source_path
echo "
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
"| sudo tee /etc/apt/sources.list  # add -a for append (>>) ;
				echo -e "\n\n sources.list update to aliyun. \n\n"
			else
				echo -e "\n\n Already is aliyun sources ! \n\n"
			fi
		else
			echo -e "\n\n Not found /etc/apt/sources.list ! \n\n"
		fi
    else
        echo -e "\n\n server is in abroad, not need change to aliyun sources! \n\n"
    fi
}

# call
set_sources_list
echo "ending"
```



### 3.2 Set Time Zone

```shell
timedatectl status
timedatectl list-timezones

# set time zone
function set_time_zone
{
    if [ -z "$(timedatectl | grep +08)" ]; then
        timedatectl set-timezone Asia/Shanghai
        echo -e "\n\n Set timezone to +08 is successful ! \n Now the datetime is $(date). \n\n"	
    else
        echo -e "\n\n Timezone is already +08 ! \n\n"
    fi
}

# set time zone
function set_time_zone
{
    if [ -z $(date +"%Z %z" | grep +08) ]; then
        echo -e "\n\n Set timezone to +08... \n\n"
        timezone_file=/etc/localtime
        backup_filepath $timezone_file
        sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai $timezone_file
        echo -e "\n\n Set timezone to +08 is successful ! \n Now the datetime is $(date). \n\n"
        # set log timezone
        dpkg-reconfigure tzdata
        service rsyslog restart
    else
        echo -e "\n\n Timezone is already +08 ! \n\n"
    fi
}
```



### Config

### 4.1 Config Vim

```shell
# Config vim
function config_vim
{
    vim_config_path=~/.vimrc
    if [ -x "$(command -v vim)" ]; then
        if ! [ -f $vim_config_path ]; then
            touch $vim_config_path
        fi
        if [ -n "$(grep "set number" $vim_config_path)" ]; then
            echo -e "\n\n Vim is already config ! \n\n"
        else
            echo "
:set number

set tabstop=4       
set shiftwidth=4    
set softtabstop=4   
set expandtab      

set autoindent     
set cindent        

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
"| sudo tee $vim_config_path
            echo -e "\n\n Set vim config successfully ! \n\n"
        fi
    else
        echo -e "\n\n Vim is not installed ! \n\n";
    fi
}

# call
config_vim
```

