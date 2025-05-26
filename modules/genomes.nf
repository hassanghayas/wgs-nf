#!/usr/bin/env nextflow

process genomes {
    tag "$sample"
    publishDir "${params.outdir}/genomes", mode: 'copy'

    input:
    path(sample)

    output:
    path("${sample}.contigs.fasta")

    script:
    """
    cp '${sample}/contigs.fasta' ${sample}.contigs.fasta
    """
}