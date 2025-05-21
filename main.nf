#!/usr/bin/env nextflow
nextflow.enable.dsl=2
/*
========================================================================================
    hassanghayas/wgs-nf
========================================================================================
    Github : https://github.com/hassanghayas/wgs-nf
    Wiki   : https://github.com/hassanghayas/wgs-nf/wiki
----------------------------------------------------------------------------------------
*/



params.samplesheet = "./samplesheet.csv"
params.out_dir      = "./results"

include { Quality_check } from './modules/QC.nf'
include { Trimming } from './modules/trimming.nf'
include { Assembly } from './modules/assembly.nf'
include { genomes } from './modules/genomes.nf'
include { MultiQC } from './modules/multiqc.nf'
include { Annotation } from './modules/annotation.nf'

workflow {
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
    Assembly(Trimming.out)

    // Run Annotation
    Annotation(Assembly.out)

    // copy genomes
    genomes(Assembly.out)

    // Run Multiqc
    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix(Quality_check.out.zip.collect())
    MultiQC(ch_multiqc_files.collect())
}