# The configfile line specifies the path to the configuration file,
# which contains URLs, file paths, and other constants used in the workflow.
configfile: "snake_config.yaml"

# The 'all' rule is typically used in Snakemake to specify the final outputs of the workflow.
# When Snakemake runs, it will try to create the files listed in the 'input' section of this rule.
rule all:
    input:
        f"{config['RESULTS_DIR']}/variants.vcf",
        f"{config['RESULTS_DIR']}/variant_stats_plot.pdf",
        f"{config['QC_DIR']}/multiqc_report.html"

# Each rule in Snakemake represents a step in the workflow.
# A rule specifies input files, output files, and the command to transform the inputs into the outputs.
rule download_reference_genome:
    output:
        ref_genome=f"{config['REF_GENOME_DIR']}/{config['REF_GENOME']}"
    shell:
        "mkdir -p {config['REF_GENOME_DIR']} && "
        "wget -P {config['REF_GENOME_DIR']} {config['REF_GENOME_URL']} && "
        "tar -xzvf {config['REF_GENOME_DIR']}/{config['REF_GENOME_ARCHIVE']} -C {config['REF_GENOME_DIR']}"

# Additional rules should follow the same pattern: defining 'input', 'output', and 'shell' or 'script' or 'run'.
# Examples include rules for downloading FASTQ files, running FastQC, Trimmomatic, etc.

# To run this Snakefile:
# 1. Ensure Snakemake is installed in your environment.
# 2. Place this Snakefile and the 'config.yaml' in your working directory.
# 3. Run the workflow with: snakemake --cores [number_of_cores]
#    Replace [number_of_cores] with the number of CPU cores you want to use.

# If you name this file differently, for example, 'MyWorkflow.smk',
# you can run it with: snakemake --snakefile MyWorkflow.smk --cores [number_of_cores]

rule download_reference_genome:
    output:
        ref_genome=f"{config['REF_GENOME_DIR']}/{config['REF_GENOME']}"
    shell:
        "mkdir -p {config['REF_GENOME_DIR']} && "
        "wget -P {config['REF_GENOME_DIR']} {config['REF_GENOME_URL']} && "
        "tar -xzvf {config['REF_GENOME_DIR']}/{config['REF_GENOME_ARCHIVE']} -C {config['REF_GENOME_DIR']}"

rule download_fastq_R1:
    output:
        fastq_R1=f"{config['FASTQ_DIR']}/R1.fastq.gz"
    shell:
        "mkdir -p {config['FASTQ_DIR']} && "
        "wget -O {output.fastq_R1} {config['FASTQ_R1_URL']}"

rule download_fastq_R2:
    output:
        fastq_R2=f"{config['FASTQ_DIR']}/R2.fastq.gz"
    shell:
        "wget -O {output.fastq_R2} {config['FASTQ_R2_URL']}"

# Additional rules for FastQC, Trimmomatic, etc.

rule bwa_index:
    input:
        ref_genome=f"{config['REF_GENOME_DIR']}/{config['REF_GENOME']}"
    output:
        f"{config['REF_GENOME_DIR']}/{config['REF_GENOME']}.bwt"
    shell:
        "bwa index {input.ref_genome}"

# Other rules follow a similar pattern
