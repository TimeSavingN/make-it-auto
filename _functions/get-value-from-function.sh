#!/bin/bash

: '
All output from echo will be returned to the variable
'
function get_value
{
  local value="hello world"
	# return
	echo "$value"
}


value=$(get_value)

echo "value: $value"
