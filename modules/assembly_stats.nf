#!/usr/bin/env nextflow

process Assembly_Stats {


    tag "stats"
    publishDir "${params.outdir}/summary", mode: 'copy'

    input:
    path input_files

    output:
    path("assembly.stats.tsv")

    script:
    """
     cat *.assembly_stats.tsv |grep -v ^seqID >>assembly.stats.tsv
     sed -i "1iseqID\tcontigs\tsize\tlargest_contig\tn50\tGC\tavg_cov" assembly.stats.tsv
    """
}