# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: Ben.Southgate@zifornd.com
# License: MIT

# Run Rank plot for visualisation of DMR output
# Can be ranked by meandiff or maxdiff - in the past was meanbetafc (which is essentially meandiff)
# some of DMRcates outputs have been changed with recent update
# At current genes of interest can be supplied as a list below - but could be implemented as a json or such format (when as None - take top genes specified as number shown)
rule rankplot:
    input:
        rds = "results/annotate.rds"
    output:
        pdf = "results/rankplot.pdf",
        tsv = "results/rankplot.tsv"
    params:
        width = 3,
        height = 5,
        textsize = 2.5,
        pad = 1,
        pointsize = 1,
        highlight = 60,
        title = "Rankplot DMRs",
        yaxis = "meandiff",
        number_show = 10,
        num_score_thres = 0.4,
        genes_of_interest = None, # list of genes of interest for plotting (otherwise will auto label)
        symbol = "symbol" # column name of annotation for nearest gene to feature for plotting
    log:
        out = "results/rankplot.out",
        err = "results/rankplot.err"
    message:
        "Run rankplot for dmrcate dmr output"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/rankplot.R"

# Saves out filtered CpG Beta Signal as BigWig tracks for visualisation
# Also saves rds obj tracks.rds 
# If combine is not None then will combine replicates as specified (can also be median)
rule tracks:
    input:
        rds = "results/filter.rds"
    output:
        rds = "results/tracks.rds" # saves as a list of GRanges objects formated as BW before being exported via rtracklayer
    params:
        anno = "hg38",
        array = "HM450",
        combine = None,
        by = "sample", # use what meta data column to combine by
        bwLocation = "results/"
    log:
        out = "results/tracks.out",
        err = "results/tracks.err"
    message:
        "Get BigWig files for CpG Tracks"
    conda:
        "envs/environment.yaml"
    script:
        "scripts/tracks.R"