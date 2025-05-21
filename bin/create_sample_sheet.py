#!/usr/bin/env python3

import os
import re
import argparse
import csv
from pathlib import Path

def parse_arguments():
    parser = argparse.ArgumentParser(
        description='Create sample sheet from a directory of FASTQ files.'
    )
    parser.add_argument('-i', '--input', required=True, help='Input directory name.')
    parser.add_argument('-o', '--output', help='Output sample sheet file name. Defaults to STDOUT.')
    parser.add_argument('-p', '--prefix', help='Prepend prefix to sequence file paths.')
    parser.add_argument('-f', '--fullpath', action='store_true', help='Use full path to files.')
    parser.add_argument('-s', '--sanitize', action='store_true', help='Replace spaces in sample names with underscores.')
    parser.add_argument('-v', '--version', action='version', version='create_sample_sheet.py v0.1.0')
    return parser.parse_args()

def collect_fastq_files(input_dir):
    return sorted([
        f for f in os.listdir(input_dir)
        if re.search(r'\.(fastq|fq)(\.gz)?$', f)
    ])

def parse_filename(filename):
    """
    Parses filenames like: AB028_S6_L001_R1_001.fastq.gz
    Returns: sample_id (AB028_S6), lane (001), read (1 or 2)
    """
    filename = filename.replace(' ', '_')
    match = re.match(r'(.+?)_L(\d{3})_R([12])', filename)
    if not match:
        return None, None, None
    sample_id = match.group(1)
    lane = match.group(2)
    read = match.group(3)
    return sample_id, lane, read

def build_sample_dict(files, input_dir):
    samples = {}
    for file in files:
        sample_id, lane, read = parse_filename(file)
        if not sample_id or not read:
            continue
        samples.setdefault(sample_id, {}).setdefault(lane, {})[read] = file
    return samples

def create_sample_sheet(samples, input_dir, output, prefix, fullpath, sanitize):
    output_handle = open(output, 'w', newline='') if output else None
    writer = csv.writer(output_handle or os.sys.stdout)

    for sample in sorted(samples.keys()):
        sample_name = sample.replace(' ', '_') if sanitize else sample
        row = [sample_name]

        for lane in sorted(samples[sample].keys()):
            for read in ['1', '2']:  # Always output R1 before R2
                file = samples[sample][lane].get(read)
                if file:
                    if fullpath:
                        path = str(Path(input_dir, file).resolve())
                    elif prefix:
                        path = f'{prefix}/{file}'
                    else:
                        path = f'{input_dir}/{file}'
                    row.append(path)

        writer.writerow(row)

    if output_handle:
        output_handle.close()

def main():
    args = parse_arguments()
    fastq_files = collect_fastq_files(args.input)
    samples = build_sample_dict(fastq_files, args.input)
    create_sample_sheet(samples, args.input, args.output, args.prefix, args.fullpath, args.sanitize)

if __name__ == '__main__':
    main()
