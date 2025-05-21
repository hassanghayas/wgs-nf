# 🧬 Bacterial Whole Genome Sequence Analysis pipeline
Nextflow pipeline for bacterial genome analysis

## Introduction
wgs-nf is a docker-based nextflow pipeline for bacterial genome assembly and annotation.
Main steps for this pipeline are:
1. Reads quality [(fastqc)](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).
2. Adapter and low quality bases Trimming [(Trimmomatic)](http://www.usadellab.org/cms/index.php?page=trimmomatic).
3. Draft genome assembly using [SPAdes](https://ablab.github.io/spades/) de-novo genome assembler.
4. Bacterial draft genome annotation with [prokka](https://github.com/tseemann/prokka).


## 💻 Installation
1. Install [`Docker`](https://docs.docker.com/engine/install/) in your laptop
2. Install [`Nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`version 22.10.6 or higher`)
3. Download pipeline or directly run pipeline on pre-defined data
```bash
nextflow pull hassanghayas/wgs-nf
```
or
```bash
nextflow run hassanghayas/wgs-nf -profile docker,test
```

## Usage
**Run wgs-nf with your own data as follow:**
```bash
nextflow run hassanghayas/wgs-nf -profile docker --samplesheet <samplesheet.csv> --outdir <results directory>
```
> [!NOTE]
> To run the pipeline create a samplesheet which contain sample name and path to the directory containing read files. Samplesheet can be created manually as shown in the example below:
```bash
sample,R1,R2
S01,full/path/S1_L002_R1_001.fastq.gz,full/path/S1_L002_R2_001.fastq.gz
S02,full/path/S2_L002_R1_001.fastq.gz,full/path/S2_L002_R2_001.fastq.gz
```
or a script can be used for automated creation of samplesheet from a directory of fastq files
```bash
wgs-nf/bin/create_samplesheet.sh <fastq files directory> > samplesheet.csv
```

### Future implementation
1. Antimicrobial resistance gene analysis
2. MLST
