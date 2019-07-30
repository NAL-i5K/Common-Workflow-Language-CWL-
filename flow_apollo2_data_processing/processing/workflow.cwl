#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:
  in_tree: string[]
  in_gff: File
  in_fasta: File

steps:
  #step 1
  faToTwoBit:
    run: faToTwoBit.cwl
    in:
      in_fasta: in_fasta
    out:
      [out_2bi] 
  #step 2
  samtools_faidx:
    run: samtools_faidx.cwl
    in:
      in_fasta: in_fasta
    out:
      [out_fai]  
  #step 3
  prepare-refseqs:
    run: prepare-refseqs.cwl
    in:
      in_fasta: in_fasta
      in_fai: samtools_faidx/out_fai
    out: 
      [out_trackList_json, out_seq, out_tracks_conf] 
  #step 4, different gff ??????
  flatfile-to-json:
    run: flatfile-to-json.cwl
    in:
      in_tree: in_tree
      in_gff: in_gff
      in_trackList_json: prepare-refseqs/out_trackList_json
    out:
      [out_trackList_json, out_tracks]
  #step 5
  generate-names:
    run: generate-names.cwl
    in:
      in_tracks: flatfile-to-json/out_tracks
    out:
      [out_names]
  #step 6
  gap2bigwig:
    run: gap2bigwig.cwl
    in:
      in_fasta: in_fasta
    out:
      [out_gaps_bigwig]
  #step 7
  GCcontent2bigwig:
    run: GCcontent2bigwig.cwl
    in:
      in_fasta: in_fasta
    out:
      [out_gc_bigwig]
  #step 8
  add-bw-track_gaps:
    run: add-bw-track_gaps.cwl
    in:
      in_gaps_bigwig: gap2bigwig/out_gaps_bigwig
      in_trackList_json: flatfile-to-json/out_trackList_json
    out:
      [out_trackList_json]
  #step 9
  add-bw-track_gc:
    run: add-bw-track_gc.cwl
    in:
      in_gc_bigwig: GCcontent2bigwig/out_gc_bigwig
      in_trackList_json: add-bw-track_gaps/out_trackList_json
    out:
      [out_trackList_json]
  #step 10
  add_metadata:
    run: add_metadata.cwl
    in:
      in_fasta: in_fasta
      in_trackList_json: add-bw-track_gc/out_trackList_json
    out:
      [out_trackList_json, out_trackList_json_bak]

outputs: 
  OUT_2bi:
    type: File
    outputSource: faToTwoBit/out_2bi
  OUT_seq:
    type: Directory
    outputSource: prepare-refseqs/out_seq
  OUT_tracks_conf:
    type: File
    outputSource: prepare-refseqs/out_tracks_conf
  OUT_tracks:
    type: Directory
    outputSource: flatfile-to-json/out_tracks
  OUT_names:
    type: Directory
    outputSource: generate-names/out_names
  OUT_gaps_bigwig:
    type: File
    outputSource: gap2bigwig/out_gaps_bigwig
  OUT_gc_bigwig:
    type: File
    outputSource: GCcontent2bigwig/out_gc_bigwig
  OUT_trackList_json:
    type: File
    outputSource: add_metadata/out_trackList_json
  OUT_trackList_json_bak:
    type: File
    outputSource: add_metadata/out_trackList_json_bak     