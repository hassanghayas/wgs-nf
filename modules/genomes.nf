#!/usr/bin/env nextflow

process copy_genomes {
    cpus 2
    tag "$sample"
    publishDir "${params.outdir}/genomes", mode: 'copy'

    input:
    tuple val(sample), path(contigs)

    output:
    tuple val(sample), path("${sample}.contigs.fasta"), emit: fasta

    script:
    """
    cp '${contigs}' ${sample}.contigs.fasta
    """
}