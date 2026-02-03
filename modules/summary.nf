#!/usr/bin/env nextflow

process Summary {


    tag "summary"
    publishDir "${params.outdir}/summary", mode: 'copy'

    input:
    path(input_files)

    output:
    path("assembly.stats.tsv")
    path("mlst.tsv") optional true

    script:
    """
    cat *.assembly_stats.tsv |grep -v ^seqID >>assembly.stats.tsv
    sed -i "1iseqID\tcontigs\tsize\tlargest_contig\tn50\tGC\tavg_cov" assembly.stats.tsv
    if find . -type l -name "*.mlst.tsv"| grep -q .; then
        cat *.mlst.tsv >>mlst.tsv
        sed -i "1iseqID\tscheme\tsequence type(ST)" mlst.tsv
    fi
    """
}