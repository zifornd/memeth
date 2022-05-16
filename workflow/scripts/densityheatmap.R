# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

densityHeatmapWrap <- function(GRset, col, samples_names, fill, cluster_columns = TRUE, clustering_distance_columns = "ks"){

  names(fill) = pData(GRset)[, col]

  ha1 = HeatmapAnnotation(group = pData(GRset)[, col], col = list(group = fill))
  
  mat <- as.matrix(getBeta(GRset))

  colnames(mat) <- pData(GRset)[, samples_names]

  p <- densityHeatmap(mat, top_annotation = ha1, 
                      cluster_columns = cluster_columns, clustering_distance_columns = "ks", 
                      ylab = "Beta-values")
  
  return(p)

}


main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  library(ComplexHeatmap)
    
  GRset <- readRDS(input$rds)

  samples_names <- params$samples_names

  col <- params$group
  
  fillList <- params$fill

  # Check if names supplied are in GRSet metadata
  stopifnot(names(fillList) %in% pData(GRset)[, col])

  fill <- sapply(pData(GRset)[, col], function(x, fillList){as.character(fillList[x])}, fillList = fillList)

  # ensure character vector in correct order for plotting
  stopifnot(names(fill) == pData(GRset)[, col])

  cluster_columns <- params$cluster_columns
  
  clustering_distance_columns <- params$clustering_distance_columns

  # Plot

  pdf(output$pdf)
  
  p <- densityHeatmapWrap(GRset, col, samples_names, fill, cluster_columns = params$cluster_columns, 
                          clustering_distance_columns = params$clustering_distance_columns)

  draw(p)

  dev.off()

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)

