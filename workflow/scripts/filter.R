# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

filterByDetP <- function(GRset, RGset){
  
  detP <- detectionP(RGSet)
  
  detP <- detP[match(featureNames(GRset),rownames(detP)),]
  
  # remove any probes that have failed in one or more samples
  keep <- rowSums(detP < 0.01) == ncol(GRset)

  # filter out bad probes
  GRset <- GRset[keep,]
  
  return(GRset)
}

filterBySexChrom <- function(GRset){
  
  annEPIC <- minfi::getAnnotation(GRset)
  keep <- !(featureNames(GRset) %in% annEPIC$Name[annEPIC$chr %in% c("chrX","chrY")])
  
  GRset <- GRset[keep,]
  
  return(GRset)
  
}

filterBySnpProbes <- function(GRset){
  
  GRset <- dropLociWithSnps(GRset, snps = c("SBE","CpG"), maf = 0)
  
  return(GRset)
  
}

filterByXReactiveProbes <- function(GRset, xprobes){
  
  xReactiveProbes <- xprobes
  
  keep <- !(featureNames(GRset) %in% xReactiveProbes$TargetID)
  
  GRset <- GRset[keep,]
  
  return(GRset)
  
}

filterByExtendedAnno <- function(GRset, anno){
  
  ### Drop all probes that are cross reactive, dont map to hg38/hg19, extended SNP annotation (see Nucleic acid research paper)
  cpg_mask <- names(anno)[anno$MASK_general == TRUE]
  
  keep <- !(featureNames(GRset) %in% cpg_mask)
  
  GRset <- GRset[keep,]
  
  return(GRset)
  
}

getAnno <- function(annoType = "hg38", array = "HM450"){

  sesameDataCache(array)

  # anno <- sesameDataGetAnno("EPIC/EPIC.hg38.manifest.rds")
  anno <- sesameDataGetAnno(paste0(array, "/", array, ".", annoType, ".manifest.rds"))

  return(anno)

}

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  library(sesameData)
    
  GRset <- readRDS(input$rds)
  
  # or could do hg38Anno <- sesameDataGetAnno("EPIC/EPIC.hg38.manifest.rds")
  # anno <- readRDS(params$anno)
  
  # Have gone with downloading the annotation per analysis - but can add to /resources if too slow
  anno <- getAnno(params$anno, params$array)
  
  RGset <- readRDS(params$rgset)
  
  # "48639-non-specific-probes-Illumina450k.csv"
  xprobes <- read.csv(file=params$xprobes, stringsAsFactors=FALSE)
  
  GRsetFilt <- filterByDetP(GRset, RGset)
  GRsetFilt <- filterBySexChrom(GRset)
  GRsetFilt <- filterBySnpProbes(GRset)
  GRsetFilt <- filterByXReactiveProbes(GRset, xprobes)
  GRsetFilt <- filterByExtendedAnno(GRset, anno)
  
  # Note we may like to add additional filtering based on updates to manifest from Illumina:
  # See https://github.com/sirselim/illumina450k_filtering

  saveRDS(GRsetFilt, file = output$rds)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
