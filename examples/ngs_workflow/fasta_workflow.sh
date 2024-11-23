#!/usr/bin/env bash

# Project: XYZ
# Date: 22 Dec 2023
# Last updated: 22 Dec 2023
# Author: ABC
# Desciption: This is a workflow to analyze FASTA file
# a
# Input:  adasdad
# Ouput: asddasasdkk 

# Global variables
# Directory setup and other global variables
OUTPUT_DIR="ecoli_analysis"
SEQ_DATA="$OUTPUT_DIR/seq"
ALIGN_DIR="$OUTPUT_DIR/align"

# Analysis steps
# Step 1: Download data
# Step 2: Preprocessing data
# Step 3: Sequence alignment
# Step 4: Calculate statistics about the alignment
# Step 5: Variant calling


# Step 1: Download data
# Download ecoli genome from NCBI with Accession number: XYY1311541
# This step should ignore downloading data if it is already downloaded before. 
function download_data(){
    echo Download data ...
    # Write more code here
}

# Step 2: Preprocessing data
function data_prep() {
    echo Preprocessing data ...
}



# Main section 
download_data
# fastqc_check
exit 1
data_prep
