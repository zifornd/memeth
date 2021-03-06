# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

plotPCA <- function(x, ...) {
  
  UseMethod("plotPCA")
  
}

plotPCA.GenomicRatioSet <- function(x, col, fill) {
  
  print(fill)
  mat <- getBeta(x)
  
  var <- matrixStats::rowVars(mat)
  
  num <- min(500, length(var))
  
  ind <- order(var, decreasing = TRUE)[seq_len(num)]
  
  pca <- prcomp(t(mat[ind, ]))
  
  pct <- (pca$sdev ^ 2) / sum(pca$sdev ^ 2)
  
  dat <- data.frame(PC1 = pca$x[,1], PC2 = pca$x[,2], group = pData(x)[, col])
  
  p <- ggplot(dat, aes_string(x = "PC1", y = "PC2", color = "group")) + 
    geom_point(size = 3) + 
    xlab(paste0("PC1: ", round(pct[1] * 100), "% variance")) + 
    ylab(paste0("PC2: ", round(pct[2] * 100), "% variance")) + 
    coord_fixed() + scale_colour_manual(values=fill)
  
  return(p)
}

main <- function(input, output, params, log) {
  
  # Log function
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script function
  
  library(ggplot2)
  
  library(minfi)
  
  x <- readRDS(input$rds)
  
  fill = strsplit(params$fill, ",")[[1]]

  p <- plotPCA(x, col = params$group, fill = fill)
  
  ggsave(output$pdf, plot = p)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)