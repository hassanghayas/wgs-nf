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
6. Identification of AMR genes using [NCBI-AMRFinderPlus](https://github.com/ncbi/amr) and [Resfinder](https://bitbucket.org/genomicepidemiology/resfinder/src/master/).
7. 16S ribosomal RNA sequence extraction using RNAmmer. 16S rRNA based taxonomic identification of bacterial isolates using BLAST.


## 💻 Installation
1. Install [`Docker`](https://docs.docker.com/engine/install/) or [`Singularity`](https://docs.sylabs.io/guides/3.0/user-guide/) in your system for pipeline reproducibility.
2. Install [`Nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`>=26.10.5`)
3. Download pipeline or directly run pipeline on pre-defined minimal test data
```bash
nextflow pull hassanghayas/wgs-nf
```
or
```bash
nextflow run hassanghayas/wgs-nf -profile <singularity/docker>,test
```

## 🗄️ Database download for 16S rRNA based ID
For taxonomic identification of bacterial isolates based on 16S ribosomal RNA (16S rRNA) sequences, the 16S_ribosomal_RNA BLAST database is required. Download the database from the following link into a user-specified directory:

https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz

Extract the downloaded database in the specified directory, or simply execute the following command:

```bash
mkdir -p ~/blastdb
cd ~/blastdb

# ncbi-blast tool should be installed in your system
update_blastdb.pl --decompress 16S_ribosomal_RNA
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
/home/$USER/.nextflow/assets/hassanghayas/wgs-nf/bin/create_samplesheet.sh <fastq files directory> > samplesheet.csv
```

### Running the pipeline
**Run wgs-nf with your own data as follow:**
```bash
nextflow run hassanghayas/wgs-nf -profile <docker/singularity> --samplesheet <samplesheet.csv> --outdir <results directory>
```

> [!NOTE]
> To run the pipeline with specific version, use `-r <version>`

### Help command
Use the --help option to display the available commands, options, and usage instructions.
```bash
$nextflow run hassanghayas/wgs-nf --help
    Usage:
    nextflow run hassanghayas/wgs-nf -profile <docker/singularity> --samplesheet <path> [other options]

    Required:
    --samplesheet      Path to CSV samplesheet with columns: sample,R1,R2

    Options:
    --outdir           Output directory for results (default: results)
    --cpus             Number of CPUs per process (default: 8)
    --memory           Amount of memory per process (e.g. '16 GB')
    --annotation       Genome annotation (default: false)
    --mlst             multi locus sequence typing (default: false)
    --amrfinder        AMRFinderPlus and ResFinder: Identify AMR genes (default: false)
    --rrna             rRNA annotation using RNAmmer (default: false)
    --taxonomy16S      16S rRNA taxonomy using BLAST (requires --rrna and --db) (default: false)
    --db               Path to BLAST database folder for 16S rRNA taxonomy (required if --taxonomy16S is true)
    --help             Show this help message

    Example:
    nextflow run hassanghayas/wgs-nf -profile docker --samplesheet samples.csv --outdir results --cpus 6 --memory '12 GB'
```

## Output
The pipeline will create result directory specified by `--outdir` parameter. Result directory contain below listed directories:

```bash
results/
├── AMR (optional)
│    ├─ NCBI_amrfinder
│    └─ resfinder
├── annotation (optional)
├── assembly
├── genomes
├── mlst (optional)
├── QC
├── rRNA (optional)
├── rRNA_taxonomy (optional)
├── summary
└── trimmed_reads
```
#### Read quality metrics (FastQC and MultiQC)
[FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/) provides general quality metrics about sequenced reads, e.g reads stats, Q scores, GC content, adapter content.  
[MultiQC](https://github.com/MultiQC/MultiQC) generates a single html report summurising QC of all the samples.

Output files:
- `QC/fastqc/`
    - `Raw_reads/<sample>/`
        - `*_fastqc.html`
        - `*_fastqc.zip`
    - `Trimmed_reads/<sample>/`
        - `*_fastqc.html`
        - `*_fastqc.zip`
- `summary/`
    - `raw_reads_multiqc.html`
    - `trimmed_reads_multiqc.html`

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

#### Antimicrobial Resistance Gene Analysis (NCBI-AMRFinderPlus)
AMR genes identification is performed using [NCBI-AMRFinderPlus](https://github.com/ncbi/amr) and [Resfinder](https://bitbucket.org/genomicepidemiology/resfinder/src/master/) tools when parameter `--amrfinder` provided while running the pipeline

Output files:
- `AMR/NCBI_amrfinder/<sample>.amrfinder.tsv`: AMR genes for each sample
- `AMR/resfinder/<sample>.resfinder.tsv`: AMR genes for each sample
- `summary/`
    - `amrfinder.combined.tsv`: combined list of AMRFinderPlus genes for all samples
    - `resfinder.combined.tsv`: combined list of ResFinder genes for all samples


#### Multilocus sequence typing (MLST)
MLST is performed using [mlst](https://github.com/tseemann/mlst) tool when parameter `--mlst` provided while running the pipeline.  

Output files:
- `mlst/<sample>.mlst.tsv`: ST for each sample
- `summary/mlst.tsv` : ST of all samples

#### 16S Ribosomal RNA annotation
16S rRNA is annotated and sequence extracted using **RNAmmer** tool when parameter `--rrna` provided while running the pipeline  
Output files:
- `rRNA/`
    - `<sample>_16SrRNA.fasta`: 16S rRNA sequence for each sample
    - `<sample>_16SrRNA.gff`: 16S rRNA annotation in gff2-version2 format for each sample

#### 16S rRNA based predicted taxonomic identification
16S rRNA based taxonomic identification of bacterial isolates is performed using **NCBI's 16S_ribosomal_RNA** blast database and **blastn** tool. `--taxonomy16S` and `-db` are required parameter for 16S rRNA based ID.  
Output files:
- `rRNA_taxonomy/<sample>_16SrRNA_taxonomy.tsv`: top 20 blast hits of 16S rRNA for each sample
- `summary/16SrRNA_taxonomy.tsv`: 16S rRNA based identification of bacterial isolates for all samples


#### Genome annotation
[prokka](https://github.com/tseemann/prokka) performs genome annotation when parameter `--annotation` provided while running the pipeline

Output files:
- `annotation/<sample>/`
    - `<sample>.txt`: annotation summary
    - `<sample>.gbk`: annotation in genbank format
    - `<sample>.gff`: annotation in gff format

## Future implementation
1. Antimicrobial resistance gene analysis (Heatmap for resistance genes)
