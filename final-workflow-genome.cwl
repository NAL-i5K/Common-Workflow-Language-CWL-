#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:
  PATH: string[]
  tree: string[]
  type: string[]
  scientific_name: string[]
  url_md5checksums: string[]
  deepPATH_genomic_fasta: string[]
  url_genomic_fasta: string[]
  deepPATH_genomic_gff: string[]
  url_genomic_gff: string[]
  deepPATH_others: string[]
  url_others: string[]
  deepPATH_apollo2_data: string[]
  deepPATH_bigwig: string[]
  host: string[]
  login_apollo2: string[]

steps:
  download:
    run: flow_download/workflow.cwl
    in:
      url_md5checksums: url_md5checksums
      url_genomic_fasta: url_genomic_fasta
      url_genomic_gff: url_genomic_gff
      url_others: url_others
    out:
      [OUT_md5checksums,   #'*.txt'
       OUT_genomic_fasta,  #'*.gz'
       OUT_genomic_gff,    #'*.gz'
       OUT_others]         #'*.gz'
  md5checksums:
    run: flow_md5checksums/workflow.cwl
    in:
      in_md5checksums: download/OUT_md5checksums
      in_genomic_fasta: download/OUT_genomic_fasta
      in_genomic_gff: download/OUT_genomic_gff
      in_others: download/OUT_others
    out:
      [
       OUT_extract,  #'*.txt2', extracted from *.txt
       OUT_check,    #'*.log', log file for execution of md5sum -c
       OUT_genomic_fasta, #'*.fa, '*.fna', '*.faa'
       OUT_genomic_gff,   #'*.gff', '*.gff3'
       OUT_others 
      ]

  #verify:
  #fasta_diff,gff3_QC......

  apollo2_data_processing:
    run: flow_apollo2_data_processing/processing/workflow.cwl
    in:
      tree: tree
      in_fasta: md5checksums/OUT_genomic_fasta
      in_gff: md5checksums/OUT_genomic_gff
    out:
      [OUT_2bi,
      OUT_seq,
      OUT_tracks_conf,
      OUT_tracks,
      OUT_names,
      OUT_gaps_bigwig,
      OUT_gc_bigwig,
      OUT_trackList_json,
      OUT_trackList_json_bak,
      ] 
  dispatch:
    run: flow_dispatch/workflow.cwl
    in:
      PATH: PATH
      tree: tree
      deepPATH_genomic_fasta: deepPATH_genomic_fasta
      in_genomic_fasta: md5checksums/OUT_genomic_fasta
      deepPATH_genomic_gff: deepPATH_genomic_gff
      in_genomic_gff: md5checksums/OUT_genomic_gff
      deepPATH_others: deepPATH_others
      #
      in_others: md5checksums/OUT_others
      in_md5checksums: download/OUT_md5checksums
      in_extract: md5checksums/OUT_extract
      in_check: md5checksums/OUT_check
      #
      deepPATH_apollo2_data: deepPATH_apollo2_data
      deepPATH_bigwig: deepPATH_bigwig
      in_2bi: apollo2_data_processing/OUT_2bi
      in_seq: apollo2_data_processing/OUT_seq
      in_tracks_conf: apollo2_data_processing/OUT_tracks_conf
      in_tracks: apollo2_data_processing/OUT_tracks
      in_names: apollo2_data_processing/OUT_names
      in_gaps_bigwig: apollo2_data_processing/OUT_gaps_bigwig
      in_gc_bigwig: apollo2_data_processing/OUT_gc_bigwig
      in_trackList_json: apollo2_data_processing/OUT_trackList_json
      in_trackList_json_bak: apollo2_data_processing/OUT_trackList_json_bak
    out:
      []
  
  apollo2_create_organism:
    run: createOrganism.cwl
    in:  
      host: host
      scientific_name: scientific_name
      PATH: PATH
      tree: tree
      in_2bi: apollo2_data_processing/OUT_2bi
      deepPATH_apollo2_data: deepPATH_apollo2_data
      login_apollo2: login_apollo2
    out:
      [out_createOrganism_log]
      
  #genomics-workspace
  genomics-workspace:
    run: flow_genomicsWorkspace/genomics-workspace-genome.cwl 
    in:
      scientific_name: scientific_name
      type: type
      in_fasta: md5checksums/OUT_genomic_fasta  
    out: []

outputs:  []
#  final_extract:
#    type: File
#    outputSource: md5checksums/OUT_extract
