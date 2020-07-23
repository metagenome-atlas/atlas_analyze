
configfile: "config.yaml"

localrules: analyze
rule analyze:
    input:
        expand("genomes/annotations/{category}.tsv",category=['KO','CAZy']),
    log:
        # optional path to the processed notebook
        notebook="Results.ipynb"
    notebook:
        "scripts/Analyis_genome_abundances.ipynb"


rule get_annotations:
    input:
        "genomes/annotations/gene2genome.tsv.gz",
        "Genecatalog/annotations/eggNog.tsv.gz"
    output:
        expand("Genecatalog/annotations/{category}.tsv",category=['KO','CAZy']),
        expand("genomes/annotations/{category}.tsv",category=['KO','CAZy']),
    resources:
        mem= config['mem']
    threads:
        1
    script:
        "scripts/get_annoatations.py"
