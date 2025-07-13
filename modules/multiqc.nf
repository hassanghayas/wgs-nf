#!/usr/bin/env nextflow

process MultiQC {

    container 'staphb/multiqc:1.28'
    tag "multiqc"
    publishDir "${params.outdir}/summary", mode: 'copy'

    input:
    path input_files

    output:
    path("multiqc_report.html")
    path("multiqc_data")

    script:
    """
    multiqc .
    """
}