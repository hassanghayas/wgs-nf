#!/usr/bin/env nextflow

process NCBI_AMRfinder {

    container "staphb/ncbi-amrfinderplus:4.2.5-2025-12-03.1"

    tag "$sample"
    publishDir "${params.outdir}/AMR/NCBI_amrfinder", mode: 'copy'

    input:
    tuple val(sample), path(fasta)

    output:
    path("${sample}.amrfinder.tsv"), emit: tsv

    script:
    """
    amrfinder -n ${fasta} --name ${sample} -o ${sample}.amrfinder.tsv
    """
}