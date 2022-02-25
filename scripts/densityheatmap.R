# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

.libPaths(new = "resources/bioconductor/platform/lib/R/library")

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  library(ComplexHeatmap)
  library(params$platform, character.only = TRUE)
  
  # tsv file location
  
  GRset <- readRDS(input$rds)

  densityHeatmap(as.matrix(getBeta(GRset)))
  
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)

