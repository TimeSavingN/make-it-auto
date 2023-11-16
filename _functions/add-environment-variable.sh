#!/bin/bash

function add_env_variable
{
	echo "Add environment variable: export $1=$2"
	cp /etc/profile "/etc/profile.bak.$(date '+%Y-%m-%d_%H-%M-%S')"
  echo "export $1=$2" >> /etc/profile
  cat /etc/profile
  source /etc/profile
}

add_env_variable "key1" "value1"
