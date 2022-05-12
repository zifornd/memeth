# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# PCA
rule pca:
    input:
        rds = "results/filter.rds"
    output:
        pdf = "results/pca.pdf"
    params:
        group = "status",
        fill = config["fill"]["pca"]
    log:
        out = "results/pca.out",
        err = "results/pca.err"
    message:
        "Run pca for normalised filtered object"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/pca.R"

# Density heatmap
rule densityheatmap:
    input:
        rds = "results/filter.rds"
    output:
        pdf = "results/densityheatmap.pdf"
    params:
        samples_names = "Sample_Name",
        group = "status",
        fill = config["fill"]["densityheatmap"],
        cluster_columns = True,
        clustering_distance_columns = "ks"
    log:
        out = "results/densityheatmap.out",
        err = "results/densityheatmap.err"
    message:
        "Run densityheatmap for normalised filtered object"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/densityheatmap.R"