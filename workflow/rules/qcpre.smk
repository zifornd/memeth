# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# run qc for methyl seq object
rule controlstripqc:
    input:
        rds = "results/import.rds"
    output:
        pdf = "results/controlstripqc.pdf"
    log:
        out = "results/controlstripqc.out",
        err = "results/controlstripqc.err"
    message:
        "Run QC for RG Set object (QC baked into minfi)"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/controlstripqc.R"

# run detection p value qc for RGset objects
rule detpqc:
    input:
        rds = "results/import.rds"
    output:
        pdf = "results/detpqc.pdf"
    params:
        fill = config["fill"]["detpqc"],
        dir = "data"
    log:
        out = "results/detpqc.out",
        err = "results/detpqc.err"
    message:
        "Plot detection p-value QC for RGSeq object"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/detpqc.R"

# run qc for methyl seq object
rule msetqc:
    input:
        rds = "results/getmset.rds"
    output:
        pdf = "results/msetqc.pdf"
    log:
        out = "results/msetqc.out",
        err = "results/msetqc.err"
    message:
        "Run QC for Methyl Set object"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/msetqc.R"
