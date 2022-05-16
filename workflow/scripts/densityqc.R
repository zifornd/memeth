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


plotDensity <- function(data, phenodata, output, fill, group = "Sample_Group"){
  
  
  ## Density plot
  pdf(output)
  
  densityPlot(data, sampGroups = phenodata[[group]], legend = F, pal = fill)
  
  legend("top", legend = levels(factor(phenodata[[group]])),
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

  phenodata <- pData(GRset)
  
  fill <- unlist(params$fill)

  # TODO See BW-31
  plotDensity(data, phenodata, output$pdf, fill, group = "status")
  

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)