# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

normalise <- function(RGset, type) {
  
  if(type == "preprocessFunnorm"){
    
    # Returns a GRset
    
    obj <- preprocessFunnorm(RGset)
  
  }
  
  if(type == "preprocessSWAN"){
    
    # NOTE - this returns an Mset not a GRset
    
    obj <- preprocessSWAN(RGset)
  
  }
  
  if(type == "preprocessQuantile"){
    
    # Returns a GRset
    
    obj <- preprocessQuantile(RGset)
  
  }
  
  if(type == "preprocessNoob"){
    
    # NOTE - this returns an Mset not a GRset
    
    obj <- preprocessNoob(RGset)
  
  }
  
  if(type == "preprocessIllumina"){
    
    # NOTE - this returns an Mset not a GRset
    # Also not recommended type of normalisation
    
    obj <- preprocessIllumina(RGset)
  
  }
  
  return(obj)
}

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  
  RGset <- readRDS(input$rds)
  
  print(sessionInfo())
  GRset <- normalise(RGset, type = params$type)
  
  saveRDS(GRset, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
