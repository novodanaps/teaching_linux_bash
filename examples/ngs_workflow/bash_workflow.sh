#!/bin/bash

# Variables for directory and filenames
WORKDIR=$PWD/NGS_Workflow
REF_GENOME_DIR="${WORKDIR}/Reference_Genome"
FASTQ_DIR="${WORKDIR}/Fastq_Data"
TRIMMED_DIR="${WORKDIR}/Trimmed_Data"
RESULTS_DIR="${WORKDIR}/Results"
QC_DIR="${RESULTS_DIR}/QC"
REF_GENOME="${REF_GENOME_DIR}/S288C_reference_sequence_R64-4-1_20230830.fasta"
REF_GENOME_ARCHIVE="S288C_reference_genome_Current_Release.tgz"
REF_GENOME_URL="http://downloads.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz"
 
FASTQ_R1_URL="https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2527nnn/GSM2527046/suppl/GSM2527046%5FAG1GY%5F128nM%5FSAM%5Foffset0%5F0%5FNeighborhoodMapping%5FR1%5F001.fastq.gz"
FASTQ_R2_URL="https://ftp.ncbi.nlm.nih.gov/geo/samples/GSM2527nnn/GSM2527046/suppl/GSM2527046%5FAG1GY%5F128nM%5FSAM%5Foffset0%5F0%5FNeighborhoodMapping%5FR2%5F001.fastq.gz"
FASTQ_R1=GSM2527046_AG1GY_128nM_SAM_offset0_0_NeighborhoodMapping_R1_001.fastq.gz
FASTQ_R2=GSM2527046_AG1GY_128nM_SAM_offset0_0_NeighborhoodMapping_R2_001.fastq.gz

# Creating directories
mkdir -p "${WORKDIR}" "${REF_GENOME_DIR}" "${FASTQ_DIR}" "${TRIMMED_DIR}" "${RESULTS_DIR}" "${QC_DIR}"
cd "${WORKDIR}"

# Step 1: Setup and Data Download
# Downloading the reference genome if it does not exist or is empty
if [ ! -s "${REF_GENOME_DIR}/${REF_GENOME_ARCHIVE}" ]; then
    wget -P "${REF_GENOME_DIR}" $REF_GENOME_URL
    tar -xzvf "${REF_GENOME_DIR}/${REF_GENOME_ARCHIVE}" -C "${REF_GENOME_DIR}"
else
    echo "Reference genome archive already exists and is not empty."
fi

# find "${REF_GENOME_DIR}" -name "*reference*.fsa.gz" -exec echo genome file: {} \;
find "${REF_GENOME_DIR}" -name "*reference*.fsa.gz" -exec gunzip -d {} >${REF_GENOME}  \;

# Downloading FASTQ files if they do not exist or are empty
if [ ! -s "${FASTQ_DIR}/${FASTQ_R1}" ]; then
    wget -P "${FASTQ_DIR}" "${FASTQ_R1_URL}"
else
    echo "FASTQ R1 file already exists and is not empty."
fi

if [ ! -s "${FASTQ_DIR}/${FASTQ_R2}" ]; then
    wget -P "${FASTQ_DIR}" "${FASTQ_R2_URL}"
else
    echo "FASTQ R2 file already exists and is not empty."
fi


# Step 2: Quality Control with FastQC
# fastqc "${FASTQ_DIR}"/*.fastq.gz -o "${QC_DIR}"


# Step 3: Read Trimming using Trimmomatic
# trimmomatic PE -phred33 \
# "${FASTQ_DIR}/${FASTQ_R1}" "${FASTQ_DIR}/${FASTQ_R2}" \
# "${TRIMMED_DIR}/trimmed_R1.fastq.gz" "${TRIMMED_DIR}/unpaired_R1.fastq.gz" \
# "${TRIMMED_DIR}/trimmed_R2.fastq.gz" "${TRIMMED_DIR}/unpaired_R2.fastq.gz" \
# LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

# exit 0 # Exit with 0 means success

# Step 4: Read Alignment
# bwa index "${REF_GENOME}"
# echo bwa mem "${REF_GENOME}" "${TRIMMED_DIR}/trimmed_R1.fastq.gz" "${TRIMMED_DIR}/trimmed_R2.fastq.gz" "\\> ${RESULTS_DIR}/aligned_reads.sam"
# Illumina paired-end reads shorter than ~70bp:
# bwa aln ref.fa read1.fq > read1.sai; bwa aln ref.fa read2.fq > read2.sai
# bwa sampe ref.fa read1.sai read2.sai read1.fq read2.fq > aln-pe.sam
bwa aln "${REF_GENOME}" "${FASTQ_DIR}/${FASTQ_R1}" > "${RESULTS_DIR}/${FASTQ_R1%.fastq.gz}.sai"
bwa aln "${REF_GENOME}" "${FASTQ_DIR}/${FASTQ_R2}" > "${RESULTS_DIR}/${FASTQ_R2%.fastq.gz}.sai"
bwa sampe "${REF_GENOME}" \
"${RESULTS_DIR}/${FASTQ_R1%.fastq.gz}.sai" "${RESULTS_DIR}/${FASTQ_R2%.fastq.gz}.sai" \
"${FASTQ_DIR}/${FASTQ_R1}" "${FASTQ_DIR}/${FASTQ_R2}" > "${RESULTS_DIR}/aligned_reads.sam"


exit 1 # Exit code different from zero means there is an error

# Step 5: Post-Alignment Processing
samtools view -bS "${RESULTS_DIR}/aligned_reads.sam" | samtools sort -o "${RESULTS_DIR}/sorted_aligned_reads.bam"
picard MarkDuplicates I="${RESULTS_DIR}/sorted_aligned_reads.bam" O="${RESULTS_DIR}/marked_duplicates.bam" M="${RESULTS_DIR}/marked_dup_metrics.txt"

# Step 6: Variant Calling
freebayes -f "${REF_GENOME_DIR}/${REF_GENOME}" "${RESULTS_DIR}/marked_duplicates.bam" > "${RESULTS_DIR}/variants.vcf"

# Step 7: Quality Control Analysis with MultiQC
multiqc "${QC_DIR}" -o "${QC_DIR}"

# Step 8: Generating a Basic Plot for Variant Statistics with R
echo "
# Load the VCF file
library(vcfR)
vcf <- read.vcfR('${RESULTS_DIR}/variants.vcf')

# Basic variant statistics
variant_summary <- summary(vcf)

# Plotting
pdf('${RESULTS_DIR}/variant_stats_plot.pdf')
plot(variant_summary)
dev.off()
" > "${RESULTS_DIR}/variant_stats.R"
Rscript "${RESULTS_DIR}/variant_stats.R"

# End of Workflow
echo "Workflow completed."
