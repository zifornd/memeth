# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

# Sets model matrix

modelMatrix <- function(data) {
  
  # Get phenotype data
  
  # data <- pData(object)

  names <- colnames(data)
  
  # Set condition factor
  
  if ("condition" %in% names) {
    
    condition <- factor(data$condition)
    
    n.condition <- nlevels(condition)
    
    is.condition <- n.condition > 1
    
  } else {
    
    is.condition <- FALSE
    
  }
  
  # Set batch factor
  
  if ("batch" %in% names) {
    
    batch <- factor(data$batch)
    
    n.batch <- nlevels(batch)
    
    is.batch <- n.batch > 1
    
  } else {
    
    is.batch <- FALSE
    
  }
  
  # Set block factor
  
  if ("block" %in% names) {
    
    block <- factor(data$block)
    
    n.block <- nlevels(block)
    
    is.block <- n.block > 1
    
  } else {
    
    is.block <- FALSE
    
  }
  
  # Construct design matrix
  
  if (is.condition & !is.batch & !is.block) {
    
    # design <- model.matrix(~ 0 + condition)
    design <- model.matrix(~ condition)
    
  }
  
  if (is.condition & is.batch & !is.block) {
    
    design <- model.matrix(~ 0 + condition + batch)
    
  }
  
  if (is.condition & !is.batch & is.block) {
    
    design <- model.matrix(~ 0 + condition + block)
    
  }
  
  if (is.condition & is.batch & is.block) {
    
    design <- model.matrix(~ 0 + condition + batch + block)
    
  }
  
  # Rename condition coefficients
  
  which.condition <- seq_len(n.condition)
  
  colnames(design)[which.condition] <- levels(condition)
  
  # Required for DMRcate
  colnames(design)[1] <- "(Intercept)"

  # Return design matrix
  
  design
  
}

# Makes sure sample tsv is in the same order as methylation object coldata

checkOrder <- function(sampledata, rds, colname = "Sample_Name") {

  sampledata <- sampledata[match(colData(rds)[[colname]],sampledata$sample),]

  return(sampledata)

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
  
  GRset <- readRDS(input$rds)

  data <- read.table(params$samples, header = T)

  data <- checkOrder(data, GRset)
  
  mod <- modelMatrix(data)
  
  #### Run DMRCate 
  
  # Already ratio converted so no need to run below:
  # GRsetRatio <- ratioConvert(GRset)

  GRsetRatio <- GRset

  arraytype = params$arraytype

  analysis.type = params$analysistype

  coef = params$coef
  
  fdr = params$fdr

  # contrasts = TRUE when we supply a limma style matrix (FALSE if design matrix)
  # design matrix must have intercept however
  cpg.annotation <- cpg.annotate("array", GRsetRatio, arraytype = arraytype,
                               analysis.type = analysis.type, design = mod, coef = coef,
                               contrasts = FALSE, fdr = fdr)

  
  write.csv(as.data.frame(cpg.annotation@ranges), file = output$csv, quote = F)

  saveRDS(cpg.annotation, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log, snakemake@config)