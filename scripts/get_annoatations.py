#!/usr/bin/env python

import pandas as pd
import numpy as np





gene2genome = pd.read_csv("genomes/annotations/gene2genome.tsv.gz",
                       index_col=[0,1], sep='\t')

gene_matrix=gene2genome.unstack(fill_value=0).Ncopies.T


# ## EggNog



E=pd.read_table("Genecatalog/annotations/eggNog.tsv.gz",index_col=0)

# map gene to KO (one gene to many KO mapping)

genes_in_genomes = gene2genome.index.levels[0]

def map_gene2annotation(header):

    mapping= E[header].dropna().str.split(',',expand=True).unstack().dropna().droplevel(0)
    mapping.name= header
    return mapping


#Filter out mapping to specific annotations
for header in ['KO','CAZy']:

    print(header)

    mapping= map_gene2annotation(header)

    if header=='KO':
        #remove prefix 'KO:'
        mapping= mapping.str[3:]

    mapping.to_csv(f'Genecatalog/annotations/{header}.tsv',sep='\t')

    # take only annotation of genes from genomes
    mapping= mapping.loc[mapping.index.intersection(genes_in_genomes).unique()]

    #map to gene matrix
    if header!='KEGG_Module':
        matrix= gene_matrix.loc[:,mapping.index].groupby(mapping.values,axis=1).sum().astype(int)


    #annotation_genome= gene2genome.join(mapping,on='Gene').groupby([header,'MAG']).Ncopies.sum()

        out_file= f'genomes/annotations/{header}.tsv'
        matrix.to_csv(out_file,sep='\t')

        #cmp= sns.clustermap(matrix.T)
        #cmp.fig.suptitle(header)
