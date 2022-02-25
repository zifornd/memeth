# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

.libPaths(new = "resources/bioconductor/platform/lib/R/library")

getData <- function(GRset, type){
  
  if(type == "beta"){
    
    data = getBeta(GRset)
    
  }
  
  if(type == "M"){
    
    data = getM(GRset)
    
  }
  
  return(data)
}


plotDensity <- function(data, phenoData, output, colour_details){
  
  
  ## Density plot
  pdf(output)
  
  densityPlot(data, sampGroups = phenoData$Sample_Group, legend = F, pal = colour_details)
  
  legend("top", legend = levels(factor(phenoData$Sample_Group)),
         text.col=colour_details)
  
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
  library(params$platform, character.only = TRUE)
  
  GRset <- readRDS(input$rds)
  
  data <- getData(GRset, params$type)
  
  phenoData <- params$phenoData
  
  colour_details <- params$colour_details
  
  plotDensity(data, phenoData, output$pdf, colour_details)
  

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)