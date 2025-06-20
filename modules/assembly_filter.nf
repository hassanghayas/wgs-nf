#!/usr/bin/env nextflow

process Assembly_filter {

    container "hassanghayas/assemblyfilter"

    tag "$sample"
    publishDir "${params.outdir}/genomes", mode: 'copy', pattern: '*.filtered.fasta'

    input:
    tuple val(sample), path(read1), path(read2), path(contigs)

    output:
    tuple val(sample), path("${sample}.filtered.fasta"), emit: fasta
    path("${sample}.assembly_stats.tsv"), emit: tsv
    path("${sample}.contig_stats.txt"), emit: txt

    script:
    """
    assembly_qc_filter.pl -c $contigs -1 $read1 -2 $read2 -o ${sample}
    """
}