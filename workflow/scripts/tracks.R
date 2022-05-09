# Get List of Granges ready to made into track

getTrackObj <- function(filter, anno = "hg38", array = "HM450", combine = "mean", by = "status"){
  
  library(TxDb.Hsapiens.UCSC.hg38.knownGene)
  
  txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene

  manifest <- readRDS(paste0("resources/", array, ".", anno, ".manifest.rds"))

  # only keep cpgs which are in final filtered Genomic Ratio set
  keep <- names(manifest) %in% featureNames(filter)
 
  manifest <- manifest[keep,]
  
  # Get Beta table from GRSet
  
  beta <- getBeta(filter)
  
  # match order of beta table with manifest meta data
  
  beta <- beta[match(names(manifest), rownames(beta)),]
  
  # check rownames equal
  
  stopifnot(rownames(beta) == names(manifest))
  
  # Add new colnames to beta table matching colData
  
  stopifnot(colnames(beta) == rownames(colData(filter)))
  
  colnames(beta) <- colData(filter)$Sample_Name
  
  # Add beta signal to tracks GRanges mcols instead of other data
  
  tracks <- manifest 
  
  mcols(tracks) <- beta
  
  # Turn into list of separate GRanges objects
  
  if (is.null(combine)) {
    
    tracksList <- lapply(colnames(mcols(tracks)), function(x, tracks){tracks[, colnames(mcols(tracks)) == x] } , tracks = tracks)
    
    names(tracksList) = colnames(mcols(tracks))
    
    tracksList <- lapply(tracksList, filterTrackOverlaps)
      
    
  } else {
    
    combine_by <- unique(colData(filter)[[by]])
    
    tracksList <- lapply(combine_by, combineBeta, tracks = tracks, colData=colData(filter), by = by, combine = combine)
    
    names(tracksList) = combine_by
    
  }
  
  
  return(tracksList)
}


combineBeta <- function(label, tracks, colData, by, combine = "mean", samplename = "Sample_Name"){
  
  library(TxDb.Hsapiens.UCSC.hg38.knownGene)
  
  txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene
  
  samples_int <- colData[colData[[by]] %in% label,][[samplename]]
  
  if(combine == "mean"){
    
    combineMeta <- rowMeans(as.data.frame(mcols(tracks[, colnames(mcols(tracks)) %in% samples_int])))
    
  } 
  
  if(combine == "median"){
    
    combineMeta <- rowMedians(as.data.frame(mcols(tracks[, colnames(mcols(tracks)) %in% samples_int])))
    
  }
  
  tracks_new <- tracks
  
  mcols(tracks_new) <- combineMeta
  
  tracks_new <- filterTrackOverlaps(tracks_new)
  
  return(tracks_new)
  
}

filterTrackOverlaps <- function(tracks){
    
    colnames(mcols(tracks)) <- "score"
  
    seqlevelsStyle(tracks) <- "UCSC"

    seqlevels(tracks) <- seqnames(seqinfo(tracks))[seqnames(seqinfo(tracks)) != "*"]

    seqinfo(tracks) <- seqinfo(txdb)[seqnames(seqinfo(tracks))[seqnames(seqinfo(tracks)) != "*"]]
  
    # take tracks which share boundaries are remove them
    tracks <- tracks[!tail(start(tracks), -1) <= head(end(tracks), -1)]
  
    # resort
    tracks <- sort(tracks)

    return(tracks)

}

saveTrack <- function(sample, tracks, fileExt = ".BigWig", location = "./"){
  
  library(rtracklayer)

  track <- tracks[sample][[1]]

  rtracklayer::export(track, paste0(location, sample, fileExt))  
  
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
    library(rtracklayer)

    filter <- readRDS(input$rds)
    
    # params
    anno <- params$anno # "hg38", "hg19"
    array <- params$array # "EPIC", "HM450"
    combine <- params$combine  # "mean", "median"
    by <- params$by # "sample"
    
    # output 
    save <- output$rds
  
    # run annotation
    tracks = getTrackObj(filter, anno, array, combine, by)
  
    # save output
    # Bigwig
    lapply(names(tracks), saveTrack, track = tracks, fileExt = ".BigWig", location = params$bwLocation )

    # Bedgraph
    lapply(names(tracks), saveTrack, track = tracks, fileExt = ".bedGraph", location = params$bwLocation)

    # save out list of GRanges 
    saveRDS(tracks, file = output$rds)

}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
