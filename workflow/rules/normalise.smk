# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

## Normalise - see minfi for normalisation options
rule normalise:
    input:
        rds = "results/import.rds"
    output:
        rds = "results/normalise.rds"
    params:
        type = "preprocessFunnorm"
    log:
        out = "results/normalise.out",
        err = "results/normalise.err"
    message:
        "Normalise RGSet (Will also ratio convert and annotate to GRSet)"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/normalise.R"