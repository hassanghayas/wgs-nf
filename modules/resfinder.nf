#!/usr/bin/env nextflow

process ResFinder {

    container "staphb/resfinder:4.7.2"

    tag "$sample"
    publishDir "${params.outdir}/AMR/resfinder", mode: 'copy'
    publishDir "${params.outdir}/AMR/resfinder", mode: 'copy', pattern: '*.resfinder.tsv'

    input:
    tuple val(sample), path(fasta)

    output:
    tuple val(sample), path("${sample}"), emit: all
    path("${sample}.resfinder.tsv"), emit: arg


    script:
    """
    python3 -m resfinder -ifa ${fasta} -o ${sample} --acquired
    awk 'BEGIN{OFS="\\t"; name="${sample}"} NR==1{print "Sample",\$0} NR>1{print name,\$0}' '${sample}/ResFinder_results_tab.txt' >'./${sample}.resfinder.tsv'
    """
}