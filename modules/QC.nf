#!/usr/bin/env nextflow

process Quality_check {

    container 'staphb/fastqc:0.12.1'

    tag "$sample"
    publishDir "${params.outdir}/QC/fastqc/${sample}", mode: 'copy'

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    path("*_fastqc.html"), emit: html
    path("*_fastqc.zip"), emit: zip

    script:
    """
    fastqc -t 4 $read1 $read2
    """
}