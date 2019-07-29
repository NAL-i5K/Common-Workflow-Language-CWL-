#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: 
      ${
        var LIST = [(inputs.in_fasta), 
                    (inputs.in_dir)];
        return LIST;
      }

baseCommand: [gap2bigwig.py]
arguments: 
  - position: 1
    prefix: -o
    valueFrom: $(inputs.in_dir.basename)/other_species/$(inputs.in_tree[0])/$(inputs.in_tree[1])/scaffold/bigwig/$(inputs.in_fasta.basename).gaps.bigwig
  - position : 3
    valueFrom: $(inputs.in_fasta.basename)

inputs:
  in_fasta:
    type: File
  in_dir:
    type: Directory
  in_tree:
    type: string[]

outputs: 
  out_dir:
    type: Directory
    outputBinding:
      glob: $(inputs.in_dir.basename)/
  out_wildcard_gaps_bigwig:
    type: File
    outputBinding: 
      glob: $(inputs.in_dir.basename)/other_species/$(inputs.in_tree[0])/$(inputs.in_tree[1])/scaffold/bigwig/$(inputs.in_fasta.basename).gaps.bigwig