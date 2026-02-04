#!/usr/bin/env nextflow

process Collate_AMR {


    tag "collate_amr"
    publishDir "${params.outdir}/summary", mode: 'copy'

    input:
    path amrfinder_files
    path resfinder_files

    output:
    path("amrfinder.absence_presence.tsv")
    path("resfinder.absence_presence.tsv")
    path("amrfinder.combined.tsv")
    path("resfinder.combined.tsv")

    script:
    """
    for i in \$(ls *.amrfinder.tsv);do tail -n +2 \$i >>amrfinder.combined.tsv;done
    for i in \$(ls *.resfinder.tsv);do tail -n +2 \$i >>resfinder.combined.tsv;done

    sed -i "1iSample\tProtein id\tContig id\tStart\tStop\tStrand\tElement symbol\tElement name\tScope\tType\tSubtype\tClass\tSubclass\tMethod\tTarget length\tReference sequence length\t% Coverage of reference\t% Identity to reference\tAlignment length\tClosest reference accession\tClosest reference name\tHMM accession\tHMM description" amrfinder.combined.tsv
    sed -i "1iSample\tResistance gene\tIdentity\tAlignment Length/Gene Length\tCoverage\tPosition in reference\tContig\tPosition in contig\tPhenotype\tAccession no." resfinder.combined.tsv

    awk '
    NR>1 {
        samples[\$1]=1
        genes[\$2]=1
        data[\$1 FS \$2]=1
    }
    END {
        # print header
        printf "sample"
        for (g in genes) printf "\t%s", g
        print ""

        # print rows
        for (s in samples) {
            printf "%s", s
            for (g in genes) {
                printf "\t%d", ( (s FS g) in data ? 1 : 0 )
            }
            print ""
        }
    }' resfinder.combined.tsv > resfinder.absence_presence.tsv

    awk '
    NR>1 {
        samples[\$1]=1
        genes[\$7]=1
        data[\$1 FS \$7]=1
    }
    END {
        # print header
        printf "sample"
        for (g in genes) printf "\t%s", g
        print ""

        # print rows
        for (s in samples) {
            printf "%s", s
            for (g in genes) {
                printf "\t%d", ( (s FS g) in data ? 1 : 0 )
            }
            print ""
        }
    }' amrfinder.combined.tsv > amrfinder.absence_presence.tsv


    """
}