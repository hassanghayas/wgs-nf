#!/usr/bin/env nextflow

process rRNA_Annotation {

    container "monicadanilevicz/rnammer:1.2"

    tag "$sample"
    publishDir "${params.outdir}/rRNA", mode: 'copy', pattern: '*_16SrRNA*'

    input:
    tuple val(sample),  path(fasta)

    output:
    tuple val(sample), path("${sample}_16SrRNA.fasta"), emit: fasta
    path("${sample}_16SrRNA.gff"), emit: gff

    script:
    """
    rnammer -S bac -m ssu -f ${sample}_16SrRNA.fasta -gff ${sample}_16SrRNA.gff - < ${fasta}
    sed -i "s/^>.*/>${sample}/" ${sample}_16SrRNA.fasta
    """
}