# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# DMRCate Cpg
# fdr: thres for filtering of cpg calling (will be used for including in DMR calling downstream)
# coef: column index from design matrix of phenotype of interest (comes from samples.tsv "condition" col) 
rule dmrcatecpg:
    input:
        rds = "results/filter.rds"
    output:
        rds = "results/{contrast}.dmrcatecpg.rds",
        csv = "results/{contrast}.dmrcatecpg.csv",
    params:
        samples = "config/samples.tsv",
        arraytype = "450K",
        analysistype = "differential",
        contrast = get_contrast,
        fdr = 0.1
    log:
        out = "results/{contrast}.dmrcatecpg.out",
        err = "results/{contrast}.dmrcatecpg.err"
    message:
        "Run dmrcate differential expression per cpg"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/dmrcatecpg.R"

# DMRCate DMR
# Liftover currently supporting hg19 to hg38
# Can rank DMRs by a number of options 
# - see https://bioconductor.org/packages/release/bioc/vignettes/DMRcate/inst/doc/DMRcate.pdf
# Others incluce: Stouffer HMFDR Fisher
rule dmrcatedmr:
    input:
        rds = "results/{contrast}.dmrcatecpg.rds"
    output:
        rds = "results/{contrast}.dmrcatedmr.rds",
        csv = "results/{contrast}.dmrcatedmr.csv"
    params:
        liftover = True,
        chainfile = "resources/hg19ToHg38.over.chain",
        fdr = "min_smoothed_fdr"
    log:
        out = "results/{contrast}.dmrcatedmr.out",
        err = "results/{contrast}.dmrcatedmr.err"
    message:
        "Run dmrcate - merge adjacent cpgs into dmrs"
    conda:
        "../envs/environment.yaml"
    script:
        "../scripts/dmrcatedmr.R"
