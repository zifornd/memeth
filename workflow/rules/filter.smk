# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# Filter non specific probes - see filter.R for more details
# Makes big difference to downstream analysis
rule filter:
    input:
        rds = "results/normalise.rds"
    output:
        rds = "results/filter.rds"
    params:
        rgset = "results/import.rds",
        xprobes = "resources/48639-non-specific-probes-Illumina450k.csv",
        anno = "hg38",
        array = "HM450",
        static = True
    log:
        out = "results/filter.out",
        err = "results/filter.err"
    message:
        "Run Filter for normailsed rds"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/filter.R"