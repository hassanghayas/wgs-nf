#!/usr/bin/env nextflow

/*
========================================================================================
    hassanghayas/wgs-nf
========================================================================================
    Github : https://github.com/hassanghayas/wgs-nf
    Wiki   : https://github.com/hassanghayas/wgs-nf/wiki
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl=2

params.samplesheet = "./samplesheet.csv"
params.outdir      = "./results"

include { Quality_check } from './modules/QC.nf'
include { Trimming } from './modules/trimming.nf'
include { Assembly } from './modules/assembly.nf'
include { copy_genomes } from './modules/genomes.nf'
include { MultiQC } from './modules/multiqc.nf'
include { Annotation } from './modules/annotation.nf'
include { Assembly_filter } from './modules/assembly_filter.nf'
include { Assembly_Stats } from './modules/assembly_stats.nf'

workflow {
    // Show help message
    if (params.help) {
        log.info """
        🧬 wgs-nf Pipeline
        Author: Hassan Ghayas (github.com/hassanghayas)

        Usage:
        nextflow run hassanghayas/wgs-nf -profile docker --samplesheet <path> [other options]

        Required:
        --samplesheet      Path to CSV samplesheet with columns: sample,R1,R2

        Options:
        --outdir           Output directory for results (default: ./results)
        --cpus             Number of CPUs per process (default: 8)
        --memory           Amount of memory per process (e.g. '16 GB')
        --annotation       Genome annotation (default: false) 
        --help             Show this help message

        Example:
        nextflow run hassanghayas/wgs-nf -profile docker --samplesheet samples.csv --outdir results --cpus 6 --memory '12 GB'

        """
        exit 0
    }

    Channel
    .fromPath(params.samplesheet)
    .splitCsv(header: true, sep: ',')
    .map { row -> 
        def sample = row.sample
        def r1 = file(row.R1)
        def r2 = file(row.R2)
        tuple(sample, r1, r2)
    }
    .set { sample_reads }

    // Run QC
    Quality_check(sample_reads)

    // Run Trimming
    Trimming(sample_reads)

    // Run Assembly
    Assembly(Trimming.out.trimmed_reads)

    // Run Assembly filter
    Trimming.out.trimmed_reads.join(Assembly.out.contigs)
    .set { filter_input }
    Assembly_filter(filter_input)

    // copy genomes
    copy_genomes(Assembly.out.contigs)

    // Run Annotation
    
    if (params.annotation) {
        Annotation(Assembly_filter.out.fasta)
    }


    // Run Multiqc
    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = Quality_check.out.zip.collect()
    MultiQC(ch_multiqc_files)

    // Assembly stats
    ch_stats_file = channel.empty()
    ch_stats_file = Assembly_filter.out.tsv.collect()
    Assembly_Stats(ch_stats_file)

}