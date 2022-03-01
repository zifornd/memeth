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
  library(ggplot2)
 
  # tsv file location
  
  MSet <- readRDS(input$rds)
    
  qc <- getQC(MSet)
  
  pdf(output$pdf)

  plotQC(qc)

  dev.off()

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)