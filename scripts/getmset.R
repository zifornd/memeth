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
  
  library(params$platform, character.only = TRUE)
  
  RGset <- readRDS(input$rds)
  
  MSet <- preprocessRaw(RGSet) 
  
  saveRDS(MSet, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
