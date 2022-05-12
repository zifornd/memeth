# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# run Density qc for GRset object
rule densityqcbeta_post:
    input:
        rds = "results/normalise.rds"
    output:
        pdf = "results/densityqcbeta_post.pdf"
    params:
        dir = "data",
        fill = config["fill"]["densityqc"],
        type = "beta"
    log:
        out = "results/densityqcbeta_post.out",
        err = "results/densityqcbeta_post.err"
    message:
        "Run Density QC for GRset object"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/densityqc.R"

# run Density qc for GRset object
rule densityqcm_post:
    input:
        rds = "results/normalise.rds"
    output:
        pdf = "results/densityqcm_post.pdf"
    params:
        dir = "data",
        fill = config["fill"]["densityqc"],
        type = "M"
    log:
        out = "results/densityqcm_post.out",
        err = "results/densityqcm_post.err"
    message:
        "Run Density QC for GRset object"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/densityqc.R"

# run Density qc for GRset object
rule boxplotqc_post:
    input:
        rds = "results/normalise.rds"
    output:
        pdf = "results/boxplotqc_post.pdf"
    params:
        dir = "data",
        fill = config["fill"]["boxplotqc"]
    log:
        out = "results/boxplotqc_post.out",
        err = "results/boxplotqc_post.err"
    message:
        "Run Boxplot QC for GRset object"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/boxplotqc.R"