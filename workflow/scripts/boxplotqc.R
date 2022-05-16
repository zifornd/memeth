# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT


plotBoxplots <- function(beta, phenodata, fill, group = "Sample_Group"){
  
  t_beta = t(beta)
  t_beta = as.data.frame(t_beta, drop=FALSE)
  t_beta$Sample_name = phenodata$Sample_Name
  t_beta$Group = as.character(phenodata[[group]])
  melt_beta = melt(t_beta)

  colnames(melt_beta) = c("Sample","Group", "CpG", "B.Val" )

  bp <- ggplot(melt_beta, aes(x=Sample, y=B.Val, fill = Group)) + 
    geom_boxplot()+
    labs(title="B vals Samples Pre Norm",x="Sample", y = "B.Val") + 
    theme_classic() + coord_flip() + scale_fill_manual(values=fill)

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
  library(reshape2)

  GRset <- readRDS(input$rds)
  
  beta <- getBeta(GRset)
  
  phenodata <- pData(GRset)
  
  fill <- unlist(params$fill)

  # TODO See BW-31
  bp <- plotBoxplots(beta, phenodata, fill, group = "status")
  
  ggsave(output$pdf, plot = bp)
  
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)