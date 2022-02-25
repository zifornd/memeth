# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT


main <- function(input, output, params, log, config) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(DMRcate)
  library(rtracklayer)
  library(minfi)
  
  cpg.annotation <- readRDS(input$rds)
  
  dmrcoutput <- dmrcate(cpg.annotation, lambda=1000, C=2)
  
  results.ranges <- extractRanges(dmrcoutput, genome = "hg19")
  
  #### Liftover
  # hg19ToHg38.over.chain from https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/
  
  path <- system.file(package="liftOver", "extdata", "hg19ToHg38.over.chain")
  
  ch <- import.chain(path)
  
  seqlevelsStyle(results.ranges) = "UCSC"  # necessary
  
  cur38 <- liftOver(results.ranges, ch)
  class(cur38)
  cur38 <- unlist(cur38)
  
  #### dmrcate output 
  results = cur38
  
  # order by fdr
  results = results[order(results$minfdr),]

  
  saveRDS(results, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)