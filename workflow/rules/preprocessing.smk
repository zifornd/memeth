# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# import original RGSet object using minfi
rule import:
    input:
        dir = "data",
        samples = "config/samples.tsv"
    output:
        rds = "results/import.rds"
    log:
        out = "results/import.out",
        err = "results/import.err"
    message:
        "Importing data..."
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/import.R"

# get MethylSet object (from RGSet)
rule getmset:
    input:
        rds = "results/import.rds"
    output:
        rds = "results/getmset.rds"
    log:
        out = "results/getmset.out",
        err = "results/getmset.err"
    message:
        "Converting RGset to MSet"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/getmset.R"

# get Ratio set object, have options for Beta and M values
rule getrset:
    input:
        rds = "results/getmset.rds"
    output:
        rds = "results/getrset.rds"
    params:
        what = "both",
        keepCN = True
    log:
        out = "results/getrset.out",
        err = "results/getrset.err"
    message:
        "Converting MSet to RSet"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/getrset.R"

# get Gene Ratio set object GRset
rule getgrset:
    input:
        rds = "results/getmset.rds"
    output:
        rds = "results/getgrset.rds"
    log:
        out = "results/getgrset.out",
        err = "results/getgrset.err"
    message:
        "Converting MSet to GRSet"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/getgrset.R"