#!/bin/bash 

SCRIPT_PATH=$(readlink -f $0)

echo script path: $(readlink -f $0)
SCRIPT_DIR=$(dirname $(readlink -f $0))

# Global variable of commonly used colors
red=31
green=32
yellow=33
blue=34
purple=35
cyan=36
white=37


echo path to install jupyterlab script: $SCRIPT_DIR/install_jupyterlab.sh 

echo path to install dependencies: ./install_jupyterlab.sh 

# Wrapper function for echo command with color
function info() {
    # $1 is the first argument passed to the function
    # $2 is the second argument passed to the function
    echo -e "\033[1;${1}m${2}\033[0m"
}

function usage(){
	info $red "${SCRIPT_PATH##/*/} -h name"
	info $green "That is how you do it."
}

if [ $# -eq 0 ]; then
	usage
fi

echo "Number of arguments: $#"
echo "Got args: $@"

function sum(){
	local a=$1
	local b=$2
	echo \$1: $a
	echo sum: $((a + b))
}

sum $2 $1
sum 42 3
