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

  targets <- read.metharray.sheet(input$dir)

  sample_table <- read.table(input$samples, header = T)

  # match targets with sample table
  targets <- targets[match(sample_table[,"sample"], targets[,"Sample_Name"]),]
  
  stopifnot(targets[,"Sample_Name"] == sample_table[,"sample"])

  # add sample table to targets
  targets <- cbind.data.frame(targets, sample_table)

  RGset <- read.metharray.exp(targets = targets)
  
  saveRDS(RGset, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
