#!/usr/bin/env nextflow

process Trimming {

    container 'staphb/trimmomatic'

    tag "$sample"
    publishDir "${params.outdir}/trimmed_reads", mode: 'copy'

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    tuple val(sample), path("${sample}.clean_1.fastq.gz"), path("${sample}.clean_2.fastq.gz")

    script:
    """
    trimmomatic PE -threads 6 $read1 $read2 \\
        ${sample}.clean_1.fastq.gz /dev/null \\
        ${sample}.clean_2.fastq.gz /dev/null \\
        ILLUMINACLIP:/Trimmomatic-0.39/adapters/NexteraPE-PE.fa:2:30:10 \\
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}