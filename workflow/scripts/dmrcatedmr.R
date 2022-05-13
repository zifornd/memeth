# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

#### Liftover
liftover <- function(results.ranges, chainfile){

  # hg19ToHg38.over.chain from https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/

  ch <- import.chain(chainfile)

  results <- rtracklayer::liftOver(results.ranges, ch)

  results <- unlist(results)
  
  return(results)
}

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
  library(ExperimentHub)
  
  cpg.annotation <- readRDS(input$rds)
  
  # Below are default values
  # fdr cutoff default applied and advised by authors
  # see opt pcutoff = "fdr"
  dmrcoutput <- dmrcate(cpg.annotation, lambda=1000, C=2)

  results.ranges <- extractRanges(dmrcoutput, genome = "hg19")
  #results.ranges <- dmrcateExtractRanges(dmrcoutput, genome = "hg19")

  seqlevelsStyle(results.ranges) <- "UCSC"

  # chainfile <- params$chainfile
  chainfile <- input$chainfile

  if(params$liftover){

    results <- liftover(results.ranges, chainfile)

  } else {

    results <- results.ranges

  }
  
  # order by fdr of choice

  fdr <- params$fdr

  results = results[order(mcols(results)[[fdr]]),]

  write.csv(as.data.frame(results), file = output$csv, quote = F)

  saveRDS(results, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)