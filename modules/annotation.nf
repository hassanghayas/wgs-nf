#!/usr/bin/env nextflow

process Annotation {

    container "staphb/prokka"

    tag "$sample"
    publishDir "${params.out_dir}/annotation", mode: 'copy'

    input:
    path(sample)

    output:
    path("${sample}-ann")

    script:
    """
    prokka --outdir '${sample}-ann' --prefix ${sample} '${sample}/contigs.fasta' \\
    --locustag $sample --mincontiglen 200
    """
}