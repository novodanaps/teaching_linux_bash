#!/bin/bash

# Function to install Miniconda
install_miniconda() {
    echo "Downloading Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p $HOME/bin/opt/mc3
    rm ~/miniconda.sh
    echo "Miniconda installed."

    # Initialize Miniconda
    source "$HOME/bin/opt/mc3/etc/profile.d/conda.sh"
    conda init bash

    # Install Mamba
    conda install -c conda-forge mamba -y
    echo "Mamba installed as the default package resolver."
}

# Prompt user for Miniconda installation
read -p "Do you want to install Miniconda? [y/N]: " install_conda
if [[ $install_conda == "y" || $install_conda == "Y" ]]; then
    install_miniconda
else
    echo "Skipping Miniconda installation."
fi

# Create Conda environment
env_name=${1:-ngs_workflow}
echo "Creating Conda environment: $env_name"
mamba create -n $env_name -y

# Activate the environment
source "$HOME/bin/opt/mc3/etc/profile.d/conda.sh"
conda activate $env_name

# Install dependencies
echo "Installing dependencies..."
mamba install -c bioconda -c conda-forge \
    bwa \
    samtools \
    picard \
    fastqc \
    multiqc \
    freebayes \
    r-base \
    r-vcfr \
    trimmomatic \
    snakemake \
    -y

echo "All dependencies installed in the Conda environment: $env_name"
