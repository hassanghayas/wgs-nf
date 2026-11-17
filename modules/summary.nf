#!/usr/bin/env nextflow

process Summary {


    tag "summary"
    publishDir "${params.outdir}/summary", mode: 'copy'

    input:
    path(input_files)

    output:
    path("assembly.stats.tsv")
    path("mlst.tsv", optional: true)
    path("16SrRNA_taxonomy.tsv", optional: true)

    script:
    """
    # assembly statistics summary for all samples
    cat *.assembly_stats.tsv |grep -v ^seqID >>assembly.stats.tsv
    sed -i "1iseqID\tcontigs\tsize\tlargest_contig\tn50\tGC\tavg_cov" assembly.stats.tsv

    # combined mlst for all samples
    if find . -type l -name "*.mlst.tsv"| grep -q .; then
        cat *.mlst.tsv >>mlst.tsv
        sed -i "1iseqID\tscheme\tsequence type(ST)" mlst.tsv
    fi

    # 16SrRNA taxonomy summary report
    if find . -type l -name "*_16SrRNA_taxonomy.tsv"| grep -q .; then
        awk 'FNR==2 {print \$0}' *_16SrRNA_taxonomy.tsv >>16SrRNA_taxonomy.tsv
        sed -i "1iSample Name\tTop Hit Taxon Name\tHit taxid\tHit accession id\tSimilarity (%)\tAlignment length\tquery cover\te value" 16SrRNA_taxonomy.tsv
    fi
    """
}