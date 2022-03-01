# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT


qcPval <- function(detP,targets, output, fill){
  

  pal <- fill
  data <- colMeans(detP)
  names(data) <- targets$Sample_Name
  
  pdf(output,width=12)
  
  par(mar = c(9,8,1,1))
  barplot(data, col = pal[factor(targets$Sample_Group)], las = 2,
          cex.names = 0.8, ylim = c(0,0.02), ylab = "Mean detection p-values")
  abline(h=0.01,col = "red")
  legend("topright", legend = levels(factor(targets$Sample_Group)), fill = pal,
         bg = "white")
  
  dev.off()
  
  # pdf(output, width = 12)
  
  # par(mar = c(9,8,1,1))
  # barplot(data, col = pal[factor(targets$Sample_Group)], las = 2,
  #         cex.names = 0.8, ylim = c(0,0.002), ylab = "Mean detection p-values\n")
  # abline(h = 0.01, col = "red")
  # legend("topright", legend = levels(factor(targets$Sample_Group)), fill = pal,
  #        bg = "white")
  
  # dev.off()

}

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
   
  # tsv file location
  
  RGset <- readRDS(input$rds)
  
  detP <- detectionP(RGset)
  #targets <- params$targets
  targets <- read.metharray.sheet(params$dir)
  fill <- strsplit(params$fill, ",")[[1]]
  qcPval(detP, targets,output$pdf, fill)
  

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)