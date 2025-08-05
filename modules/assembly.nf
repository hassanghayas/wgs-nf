#!/usr/bin/env nextflow

process Assembly {

    container "staphb/spades:4.2.0"

    tag "$sample"
    publishDir "${params.outdir}/assembly", mode: 'copy'

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    // grab all output
    tuple val(sample), path("${sample}"), emit: all
    tuple val(sample), path("${sample}/contigs.fasta"), emit: contigs

    script:
    """
    mkdir -p ${sample}
    spades.py -t ${task.cpus} -o ${sample} -1 $read1 -2 $read2 --cov-cutoff auto
    """
}
