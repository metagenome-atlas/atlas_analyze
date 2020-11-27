
configfile: "config.yaml"

import os,sys



scripts_dir= os.path.join(os.path.dirname(os.path.abspath(workflow.snakefile)),"scripts")
sys.path.append(scripts_dir)


Files_to_import={
    "genomes/checkm/completeness.tsv": "Results/genome_completeness.tsv",
    'genomes/counts/raw_counts_genomes.tsv': 'Results/counts/raw_counts_genomes.tsv',
    "genomes/counts/median_coverage_genomes.tsv": "Results/counts/median_coverage_genomes.tsv",
    "genomes/annotations/KO.tsv": "Results/annotations/KO.tsv" ,
    "genomes/annotations/CAZy.tsv": "Results/annotations/CAZy.tsv",
}


rule all:
    input:
        "Results/Summary.html"

onsuccess:
    print(f"Analysis finished. Have a look at the {os.path.abspath('.')}/Results/Summary.html")

localrules: analyze, get_taxonomy, import_files


rule import_files:
    input:
        Files_to_import.keys()
    output:
        Files_to_import.values()
    run:
        import shutil

        for file in input:

            shutil.copy(file,Files_to_import[file])


rule get_taxonomy:
    input:
        "genomes/taxonomy/gtdb/gtdbtk.bac120.summary.tsv"
    output:
        "Results/taxonomy.tsv"
    script:
        "scripts/get_taxonomy.py"




# rule copy_scripts:
#     input:
#         f"{scripts_dir}/utils",
#         f"{scripts_dir}/Analyis_genome_abundances.ipynb"
#     output:
#         directory("Results/scripts"),
#
#
#     run:
#         os.makedirs(output[0])
#
#         import shutil
#         for f in input:
#             shutil.copy(f, output[0])



rule analyze:
    input:
        "Results/taxonomy.tsv",
        "Results/mapping_rate.tsv",
        Files_to_import.values(),
        expand("Results/annotations/{category}.tsv",category=['KO','CAZy']),
    log:
        # optional path to the processed notebook
        notebook="Results/Code.ipynb"
    notebook:
        "scripts/Analyis_genome_abundances.ipynb"

rule convert_nb:
    input:
        "Results/Code.ipynb"
    output:
        "Results/Summary.html"
    shell:
        "jupyter nbconvert --output Summary --to=html --TemplateExporter.exclude_input=True {input}"

rule get_mapping_rate:
    input:
        read_counts= "stats/read_counts.tsv",
        mapped='genomes/counts/raw_counts_genomes.tsv'
    output:
        "Results/mapping_rate.tsv"
    run:
        import pandas as pd


        Nreads= pd.read_table(input.read_counts, index_col=[0,1])

        Counts= pd.read_csv(input.mapped,index_col=0,sep='\t').T

        mapping_rate =  Counts.sum(1)/( 2* Nreads.Total_Reads.unstack().QC)
        mapping_rate.name='Mapping_rate'

        mapping_rate.to_csv(output[0],sep='\t',header=True)






rule get_annotations:
    input:
        "genomes/annotations/gene2genome.tsv.gz",
        "Genecatalog/annotations/eggNog.tsv.gz"
    output:
        expand("genomes/annotations/{category}.tsv",category=['KO','CAZy']),
        expand("Genecatalog/annotations/{category}.tsv",category=['KO','CAZy']),
    resources:
        mem= config['mem']
    threads:
        1
    script:
        "scripts/get_annoatations.py"
