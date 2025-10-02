# 🧬 Bacterial Whole Genome Sequence Analysis pipeline
Nextflow pipeline for bacterial genome analysis

## Introduction
wgs-nf is a nextflow pipeline for bacterial genome assembly and annotation.
Main steps for this pipeline are:
1. Reads quality [(fastqc)](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).
2. Adapter and low quality bases Trimming [(Trimmomatic)](http://www.usadellab.org/cms/index.php?page=trimmomatic).
3. Draft genome assembly using [SPAdes](https://ablab.github.io/spades/) de-novo genome assembler.
4. Bacterial draft genome annotation with [prokka](https://github.com/tseemann/prokka).
5. Mulit locus sequence typing (MLST) using [mlst](https://github.com/tseemann/mlst).


## 💻 Installation
1. Install [`Docker`](https://docs.docker.com/engine/install/) or [`Singularity`](https://docs.sylabs.io/guides/3.0/user-guide/) in your system for pipeline reproducibility.
2. Install [`Nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`>=22.10.6`)
3. Download pipeline or directly run pipeline on pre-defined minimal test data
```bash
nextflow pull hassanghayas/wgs-nf
```
or
```bash
nextflow run hassanghayas/wgs-nf -profile <singularity/docker>,test
```

## Usage

### Samplesheet input
To run this pipeline create a samplesheet with information about your samples. it has to be comma-seperated with 3 columns. See below example:
```bash
sample,R1,R2
S01,full/path/S1_L002_R1_001.fastq.gz,full/path/S1_L002_R2_001.fastq.gz
S02,full/path/S2_L002_R1_001.fastq.gz,full/path/S2_L002_R2_001.fastq.gz
```
Script is provided for automated creation of samplesheet from a directory of fastq files.
```bash
wgs-nf/bin/create_samplesheet.sh <fastq files directory> > samplesheet.csv
```

### Running the pipeline
**Run wgs-nf with your own data as follow:**
```bash
nextflow run hassanghayas/wgs-nf -profile <docker/singularity> --samplesheet <samplesheet.csv> --outdir <results directory>
```

> [!NOTE]
> To run the pipeline with specific version, use `-r <version>`

## Output
The pipeline will create result directory specified by `--outdir` parameter. Result directory contain below listed directories:

```bash
results/
├── annotation (optional)
├── assembly
├── genomes
├── mlst
├── QC
├── summary
└── trimmed_reads
```
#### Read quality metrics (FastQC and MultiQC)
[FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/) provides general quality metrics about sequenced reads, e.g reads stats, Q scores, GC content, adapter content.  
[MultiQC](https://github.com/MultiQC/MultiQC) generates a single html report summurising QC of all the samples.

Output files:
- `QC/fastqc/<sample>/`
    - `*_fastqc.html`
    - `*_fastqc.zip`
- `summary/multiqc_report.html`

#### Reads Trimming
[(Trimmomatic)](http://www.usadellab.org/cms/index.php?page=trimmomatic) trims low quality bases and adaptor from the reads

Output files:
- `trimmed_reads/`
    - `<sample>.clean_1.fastq.gz`
    - `<sample>.clean_2.fastq.gz`

#### Genome assembly
[SPAdes](https://ablab.github.io/spades/) performs de novo assembly using trimmed reads

Output files:
- `assembly/<sample>/`
    - `contigs.fasta`: assembly in fasta format
- `genomes/<sample>.fasta`: assembly in fasta format from `assembly/<sample>` folder

#### Assembly filter and stats
assembly filter is performed based on minimum contig size (200bp) and minimum coverage of contig (5x). assembly stats provides no. of contigs, GC content, genome size, N50 and average depth of coverage.

Output files:
- `genomes/<sample>.filtered.fasta`: filtered assembly in fasta format
- `summary/assembly.stats.tsv`: assembly statistics of all samples in project

#### Multilocus sequence typing (MLST)
MLST is performed using [mlst](https://github.com/tseemann/mlst) tool when parameter `--mlst` provided while running the pipeline

Output files:
- `mlst/<sample>.mlst.tsv`: ST for each sample
- `summary/mlst.tsv` : ST of all samples

#### Genome annotation
[prokka](https://github.com/tseemann/prokka) performs genome annotation when parameter `--annotation` provided while running the pipeline

Output files:
- `annotation/<sample>/`
    - `<sample>.txt`: annotation summary
    - `<sample>.gbk`: annotation in genbank format
    - `<sample>.gff`: annotation in gff format

## Future implementation
1. Antimicrobial resistance gene analysis
