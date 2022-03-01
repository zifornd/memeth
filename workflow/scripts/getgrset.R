# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  
  RSet <- readRDS(input$rds)
  
  GRset <- mapToGenome(RSet)
  
  saveRDS(GRset, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
