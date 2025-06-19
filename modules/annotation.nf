#!/usr/bin/env nextflow

process Annotation {

    container "staphb/prokka"

    tag "$sample"
    publishDir "${params.outdir}/annotation", mode: 'copy'

    input:
    tuple val(sample), path(contigs)

    output:
    tuple val(sample), path("${sample}"), emit: all
    tuple val(sample), path("${sample}/${sample}.txt"), emit: summary
    tuple val(sample), path("${sample}/${sample}.gff"), emit: gff
    tuple val(sample), path("${sample}/${sample}.gbk"), emit: gbk
    tuple val(sample), path("${sample}/${sample}.faa"), emit: proteins
    tuple val(sample), path("${sample}/${sample}.ffn"), emit: genes
    tuple val(sample), path("${sample}/${sample}.fna"), emit: genome

    script:
    """
    prokka --outdir '${sample}' --prefix ${sample} '${contigs}' \\
    --locustag $sample --mincontiglen 200
    """
}