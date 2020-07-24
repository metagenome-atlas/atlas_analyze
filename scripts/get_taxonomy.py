#!/usr/bin/env python

import pandas as pd
import numpy as np


from utils.mag_scripts import tax2table


DT= pd.read_table(snakemake.input[0],index_col=0)
Tax= tax2table(DT.classification, remove_prefix=True)
Tax.to_csv(snakemake.output[0],sep='\t')
