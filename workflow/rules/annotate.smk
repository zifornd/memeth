# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# Annotate DMRs with closest gene
rule annotate:
    input:
        rds = "results/dmrcatedmr.rds"
    output:
        rds = "results/annotate.rds",
        csv = "results/annotate.csv",
        bed = "results/annotate.bed"
    params:
        outputLoc = "nearestLocation",
        featureLocForDistance = "TSS",
        bindingRegion = [-2000, 2000]
    log:
        out = "results/annotate.out",
        err = "results/annotate.err"
    message:
        "Run annotation of dmrs"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/annotate.R"
