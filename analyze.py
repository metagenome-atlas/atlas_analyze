#!/usr/bin/env python3

import os,sys
from snakemake.shell import shell



import argparse

parser = argparse.ArgumentParser()
parser.add_argument('atlas_folder')
namespace, snakemake_args= parser.parse_known_args(sys.argv[1:])
atlas_folder= namespace.atlas_folder

if not (os.path.exists(atlas_folder) & os.path.exists(os.path.join(atlas_folder,'config.yaml'))):

    raise IOError("First argument must be the path to the working folder of an atlas run with a config.yaml inside. ")




shell(
    "snakemake "
    "-d {atlas_folder} "
    "-j 1 "
    "{snakemake_args}"
    )
