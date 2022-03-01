# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT


getData <- function(GRset, type){
  
  if(type == "beta"){
    
    data = getBeta(GRset)
    
  }
  
  if(type == "M"){
    
    data = getM(GRset)
    
  }
  
  return(data)
}


plotDensity <- function(data, phenodata, output, fill){
  
  
  ## Density plot
  pdf(output)
  
  densityPlot(data, sampGroups = phenodata$Sample_Group, legend = F, pal = fill)
  
  legend("top", legend = levels(factor(phenodata$Sample_Group)),
         text.col=fill)
  
  dev.off()
  
  
  
}

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  library(ggplot2)
  
  GRset <- readRDS(input$rds)
  
  data <- getData(GRset, params$type)

  #phenodata <- read.metharray.sheet(params$dir)
  
  phenodata <- pData(GRset)

  fill <- strsplit(params$fill, ",")[[1]]
  
  plotDensity(data, phenodata, output$pdf, fill)
  

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)