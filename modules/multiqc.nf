#!/usr/bin/env nextflow

process MultiQC {

    container 'staphb/multiqc'
    tag "multiqc"
    publishDir "${params.outdir}/QC", mode: 'copy'

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