# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# Annotate DMRs with closest gene
rule annotate:
    input:
        rds = "results/{contrast}.dmrcatedmr.rds"
    output:
        rds = "results/{contrast}.annotate.rds",
        csv = "results/{contrast}.annotate.csv",
        bed = "results/{contrast}.annotate.bed"
    params:
        outputLoc = "nearestLocation",
        featureLocForDistance = "TSS",
        bindingRegion = [-2000, 2000]
    log:
        out = "results/{contrast}.annotate.out",
        err = "results/{contrast}.annotate.err"
    message:
        "Run annotation of dmrs"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/annotate.R"
