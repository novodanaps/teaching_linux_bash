#!/bin/bash

# Function to start Jupyter Lab
start_jupyter_lab() {
    echo "Starting Jupyter Lab..."
    nohup jupyter lab --no-browser &> /dev/null &
    sleep 3  # Wait a bit for the server to start
    jupyter lab list | grep http | awk '{print $1}'  # Extract and print the URL
    echo "Jupyter Lab is running. Open the above URL in your browser."
}

# Main script execution
if command -v jupyter-lab &> /dev/null; then
    start_jupyter_lab
else
    echo "Jupyter Lab is not detected in the current environment."
    echo "Please ensure you have activated the correct Python or Conda environment where Jupyter Lab is installed."
fi

# End of script
