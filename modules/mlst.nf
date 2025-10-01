#!/usr/bin/env nextflow

process MLST {

    container "staphb/mlst:2.23.0-2024-12-31"

    tag "$sample"
    publishDir "${params.outdir}/mlst", mode: 'copy'

    input:
    tuple val(sample), path(fasta)

    output:
    path("${sample}.mlst.tsv"), emit: tsv

    script:
    """
    mlst --quiet --threads ${task.cpus} --label ${sample} ${fasta} > ${sample}.mlst.tsv
    """
}