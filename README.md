# CWL, Common-Workflow-Language 
## What is CWL? :octocat:
- a tool to make our organism onboarding pipeline easy to maintain
- design functional blocks, and concatenate them to make a complete working pipeline
- an I/O pipeline

## How does CWL look like? :metal:
- All **<.cwl>** files are same between organism, and **<.yml>** file need to be customize for specific organism.

##  Ultimate goal :+1:
- finish all works with only one single command
```
cwl-runner workflow.cwl job.yml
```

## File explanation :tada:
- **block** : It is the basic functional structure, like a building brick. I copy from block_sample if I develope a new block.
- **demo_workflow**: These demo directory try to see how the connecting block work, and the most important file is \*-workflow.cwl. Other cwl files are copy from block\* folder.
- **storage**: It is a recycle bin.  
- **flow_apollo2**: I break down the apollo2 onstage step in data wrangling into 11 CWL steps.   
[Here is the link of original shell script file](https://gitlab.com/i5k_Workspace/apollo2_data_build_scripts/blob/master/build_apollo2_flatfiles.sh)

## Miscellaneous :rocket:
- One thing worth mentioning when developing, so not write to many comment in cwl files, it may probably cause permanentfail.

