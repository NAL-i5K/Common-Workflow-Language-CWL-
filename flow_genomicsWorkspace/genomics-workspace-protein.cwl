#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement

inputs:
  in_fasta_protein: File[]
  scientific_name: string[]
  in_dummy: File
steps:
  #step 1
  addfile_2_hmmer:
    run: addfile_2_hmmer.cwl
    scatter: in_fasta
    in:
      in_fasta: in_fasta_protein
    out:
      [out_dummy]
  #step 2
  addblast:
    run: addblast-protein.cwl
    scatter: [in_fasta, in_dummy]
    scatterMethod: dotproduct    
    in:
      scientific_name: scientific_name
      in_fasta: in_fasta_protein
      in_dummy: addfile_2_hmmer/out_dummy
    out:
      [out_dummy] 
  #step 3
  makeblastdb:
    run: makeblastdb.cwl
    scatter: [in_fasta, in_dummy]
    scatterMethod: dotproduct
    in:
      in_fasta: in_fasta_protein
      in_dummy: addblast/out_dummy
    out:
      [out_dummy]
  #step 4
  populatesequence:
    run: populatesequence.cwl
    scatter: [in_fasta, in_dummy]
    scatterMethod: dotproduct
    in:
      in_fasta: in_fasta_protein
      in_dummy: makeblastdb/out_dummy
    out:
      [out_dummy]
  #step 5
  showblast:
    run: showblast.cwl
    scatter: [in_fasta, in_dummy]
    scatterMethod: dotproduct
    in:
      in_fasta: in_fasta_protein
      in_dummy: populatesequence/out_dummy
    out:
      [out_dummy]
  #step 6
  addhmmer:
    run: addhmmer-protein.cwl
    scatter: [in_fasta, in_dummy]
    scatterMethod: dotproduct
    in:
      in_fasta: in_fasta_protein
      scientific_name: scientific_name
      in_dummy: showblast/out_dummy
    out: [out_dummy]

outputs:
  out_dummy:
    type: File[]
    outputSource: addfile_2_hmmer/out_dummy 
 
