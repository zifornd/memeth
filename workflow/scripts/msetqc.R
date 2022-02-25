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
  library(ggplot2)
  library(params$platform, character.only = TRUE)
  
  # tsv file location
  
  MSet <- readRDS(input$rds)
  
  baseDir <- params$baseDir
  
  qc <- getQC(MSet)
  
  # I think is ggplot2 obj
  #pdf(paste0(baseDir, "/QC_Meth_Unmeth/QCPlot_PreNorm.pdf"))
  p = plotQC(qc)
  #dev.off()
  
  ggsave(output$pdf, plot = p)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)