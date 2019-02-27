#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: 
      ${
        var LIST = [inputs.in_gff, inputs.in_dir];
        return LIST;
      }
baseCommand: [cp]
arguments: 
  - position: 1
    valueFrom: $(inputs.in_gff.basename)
  - position: 2
    valueFrom: $(inputs.in_dir.basename)/other_species/$(inputs.in_tree[0])/$(inputs.in_tree[1])/scaffold/analyses/$(inputs.in_tree[2])_Annotation_Release_$(inputs.in_tree[3].split('_')[1])

inputs: 
  in_dir:
    type: Directory
  in_tree:
    type: string[]
  in_gff:
    type: File
      
outputs: [] 