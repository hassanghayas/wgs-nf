#!/usr/bin/env nextflow

process ResFinder {

    container "staphb/resfinder:4.7.2"

    tag "$sample"
    publishDir "${params.outdir}/AMR/resfinder", mode: 'copy'
    publishDir "${params.outdir}/AMR/resfinder", mode: 'copy', pattern: '*.results.tsv'

    input:
    tuple val(sample), path(fasta)

    output:
    tuple val(sample), path("${sample}"), emit: all
    tuple val(sample), path("${sample}.results.tsv"), emit: arg
    tuple val(sample), path("${sample}.json"), emit: json

    script:
    """
    python3 -m resfinder -ifa ${fasta} -o ${sample} --acquired -j ${sample}.json
    cp '${sample}/ResFinder_results_tab.txt' './${sample}.results.tsv'
    """
}