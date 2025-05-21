#!/usr/bin/env nextflow

process Assembly {

    container "staphb/spades"

    tag "$sample"
    publishDir "${params.out_dir}/assembly", mode: 'copy'

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    path("${sample}")

    script:
    """
    mkdir -p ${sample}
    spades.py -t 6 -o ${sample} -1 $read1 -2 $read2 --cov-cutoff auto
    """
}
