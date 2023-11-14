#!/bin/bash

# Function to install Jupyter Lab and Bash kernel using Python venv
install_jupyter_venv() {
    echo "Setting up Python virtual environment and installing Jupyter Lab..."
    python3 -m venv jupyter_venv
    source jupyter_venv/bin/activate
    pip install jupyterlab
    pip install bash_kernel
    python -m bash_kernel.install
    echo "Jupyter Lab and Bash kernel installation complete. Use 'source jupyter_venv/bin/activate' to activate the virtual environment."
}

# Function to install Miniconda, Jupyter Lab, and Bash kernel
install_jupyter_miniconda() {
    local install_path="$HOME/bin/opt/mc3"
    echo "Installing Miniconda in $install_path..."

    # Downloading Miniconda installer
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p "$install_path"
    rm miniconda.sh

    # Initializing Miniconda
    source "$install_path/bin/activate"

    # Configuring conda-libmamba-solver
    conda install -n base conda-libmamba-solver
    conda config --set solver libmamba

    # Installing Jupyter Lab and Bash kernel
    conda install -c conda-forge jupyterlab
    conda install -c conda-forge bash_kernel

    echo "Miniconda, Jupyter Lab, and Bash kernel installation complete."
}

# Main script execution
echo "Do you want to install Jupyter Lab using Miniconda? [yes/NO]"
read -r user_response

if [[ $user_response == "yes" ]]; then
    install_jupyter_miniconda
else
    install_jupyter_venv
fi

# End of script
