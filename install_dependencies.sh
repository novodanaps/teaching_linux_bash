#!/bin/bash

# Update package list
sudo apt-get update

# Function to update package list and install a package

install_package() {
    local package=$1
    echo "Installing $package..."
    sudo apt-get install -y "$package"
}

# Installing Pandoc
install_package "pandoc"

# Installing Git
install_package "git"

# Installing Vim
install_package "vim"

# Installing Python3 and venv
# Python3 should come pre-installed in Ubuntu 20.04, but we'll include it just in case.
install_package "python3"
install_package "python3-venv"

echo "All essential dependencies are installed."
