#!/usr/bin/env nextflow

process MultiQC {

    container 'staphb/multiqc:1.28'
    tag "multiqc"
    publishDir "${params.outdir}/summary", mode: 'copy', pattern: '*.html'

    input:
    path input_files
    val report_name

    output:
    path("${report_name}_multiqc.html")
    path("${report_name}_multiqc_data.zip")

    script:
    """
    multiqc -z --filename ${report_name}_multiqc.html .
    """
}