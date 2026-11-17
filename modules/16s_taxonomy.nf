#!/usr/bin/env nextflow

process rRNA_Taxonomy {

    container "staphb/blast:2.17.0"
    containerOptions "--volume ${params.db}:/blastdb:ro --env BLASTDB=/blastdb"
    

    tag "$sample"
    publishDir "${params.outdir}/rRNA_taxonomy", mode: 'copy', pattern: '*.tsv'

    input:
    tuple val(sample),  path(fasta)

    output:
    path("${sample}_16SrRNA_taxonomy.tsv"), emit: tsv

    script:
    """
    blastn -db /blastdb/16S_ribosomal_RNA -query ${fasta} -outfmt "6 qseqid sscinames staxids sseqid pident length qcovs evalue" -max_target_seqs 20 -out ${sample}_16SrRNA_taxonomy.tsv
    sed -i "1i#Sample\tHit Taxon Name\tHit taxid\tHit accession id\tSimilarity (%)\tAlignment length\tquery cover\te value" ${sample}_16SrRNA_taxonomy.tsv
    """
}