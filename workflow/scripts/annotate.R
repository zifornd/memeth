###### Annotate DMRs 

addAnno <- function(dmrs, outputLoc = "nearestLocation", featureLocForDistance="TSS", 
                    bindingRegion=c(-2000, 2000)){

    library(TxDb.Hsapiens.UCSC.hg38.knownGene)
    library(GenomicRanges)
    library(ChIPpeakAnno)
    library(org.Hs.eg.db)
    
    dmrs = GRanges(dmrs)
    
    annoData <- toGRanges(TxDb.Hsapiens.UCSC.hg38.knownGene)
    
    seqlevelsStyle(dmrs) <- seqlevelsStyle(annoData)
    
    anno_dmrs <- annotatePeakInBatch(dmrs, AnnotationData = annoData, 
                                    output = outputLoc, 
                                    FeatureLocForDistance = featureLocForDistance,
                                    bindingRegion = bindingRegion)
    
    
    
    anno_dmrs$symbol <- xget(anno_dmrs$feature, org.Hs.egSYMBOL)
    
    return(anno_dmrs)
  
}


main <- function(input, output, params, log) {
  
    # Log
    
    out <- file(log$out, open = "wt")
    
    err <- file(log$err, open = "wt")
    
    sink(out, type = "output")
    
    sink(err, type = "message")
    
    # Script
    
    library(minfi)
    library(DMRcate)

    dmrs <- readRDS(input$rds)
    
    # params
    outputLoc <- params$output # "nearestLocation"
    featureLocForDistance <- params$featureLocForDistance # "TSS"
    bindingRegion <- params$bindingRegion  # c(-2000, 2000)

    # output 
    save <- output$csv
  
    # run annotation
    dmrs = addAnno(dmrs, outputLoc, featureLocForDistance, bindingRegion)
    
    # save output

    write.csv(as.data.frame(dmrs), save)

    saveRDS(dmrs, file = output$rds)


}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
