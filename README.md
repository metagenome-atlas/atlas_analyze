# atlas_analyze
Scripts to get the most of the output of metagenome-atlas


Here are some scripts to analyze the output of metagenome-atlas >= v2.3

## Get started
To get started download this repo.

```
git clone https://github.com/metagenome-atlas/atlas_analyze.git
cd atlas_analyze
```


Get mamba the faster version of conda

`conda install -c conda-forge mamba `


### Easy set up

```
./setup.sh
mamba activate analyze
```

### Start analyzing
```

analyze.py path/to/atlas_workingdir

``


For an example see this [notebook](scripts/Analyis_genome_abundances.ipynb)
