# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore
# Email: james.ashmore@zifornd.com, ben.southgate@zifornd.com
# License: MIT

import pandas as pd
from pathlib import Path
from snakemake.utils import validate

### Validating inputs require schema implementation

# TODO add schemas BW-26
validate(config, schema="../schemas/config.schema.yaml")

# default ‘\t’ not picking up samples.tsv header
samples = pd.read_csv(config["samples"], sep = "\s+", engine='python').set_index("sample", drop=False).sort_index()

# TODO add schemas BW-26
validate(samples, schema="../schemas/samples.schema.yaml")

def get_final_output():

    output = [
        "results/import.rds",
        "results/getmset.rds",
        "results/getrset.rds",
        "results/detpqc.pdf",
        "results/msetqc.pdf",
        "results/getgrset.rds",
        "results/densityqcbeta_pre.pdf",
        "results/densityqcm_pre.pdf",
        "results/controlstripqc.pdf",
        "results/boxplotqc_pre.pdf",
        "results/normalise.rds",
        "results/densityqcbeta_post.pdf",
        "results/densityqcm_post.pdf",
        "results/boxplotqc_post.pdf",
        "results/filter.rds",
        "results/pca.pdf",
        "results/densityheatmap.pdf",
        "results/tracks.rds",
    ]

    # TODO add contrast to config BW-18

    contrasts = config["contrasts"]

    # TODO add contrast names to output files BW-21

    for contrast in contrasts:

        output.append(f"results/{contrast}.dmrcatecpg.rds")

        output.append(f"results/{contrast}.dmrcatecpg.csv")

        output.append(f"results/{contrast}.dmrcatedmr.rds")

        output.append(f"results/{contrast}.dmrcatedmr.csv")

        output.append(f"results/{contrast}.annotate.csv")

        output.append(f"results/{contrast}.annotate.bed")

        output.append(f"results/{contrast}.rankplot.pdf")

        output.append(f"results/{contrast}.rankplot.tsv")

    return output

# TODO add contrast to config BW-18

def get_contrast(wildcards):

    return config["contrasts"][wildcards.contrast]