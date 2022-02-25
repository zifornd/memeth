# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

.libPaths(new = "resources/bioconductor/platform/lib/R/library")


plotBoxplots <- function(beta, phenoData, colour_details){
  
  t_beta = t(beta)
  t_beta = as.data.frame(t_beta, drop=FALSE)
  t_beta$Sample_name = phenoData$Sample_Name
  t_beta$Group = as.character(phenoData$Sample_Group)
  melt_beta = melt(t_beta)

  colnames(melt_beta) = c("Sample","Group", "CpG", "B.Val" )

  bp <- ggplot(melt_beta, aes(x=Sample, y=B.Val, fill = Group)) + 
    geom_boxplot()+
    labs(title="B vals Samples Pre Norm",x="Sample", y = "B.Val") + 
    theme_classic() + coord_flip() + scale_fill_manual(values=colour_details)

  return(bp)
  
  
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
  beta <- getBeta(GRset)
  
  phenoData <- params$phenoData
  
  colour_details <- params$colour_details
  
  bp <- plotBoxplots(beta, phenoData, colour_details)
  
  ggsave(output$pdf, plot = bp)
  
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)