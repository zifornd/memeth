
# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT

# extract columns from DMRCate results for input into rank plot function
prepRes <- function(results, yaxis = "meandiff", symbol = "overlapping.genes"){

  results <- as.data.frame(mcols(results)[,c(symbol, yaxis)])
  
  # Change colnames (expects data parsed as symbol, enrichment)

  colnames(results) <- c("symbol","score")
  
  # Rank by value

  results <- results[order(-results$score),]

  results$rank <- rep(1:length(results$score))

  return(results)
}

#### Mean diff rank plots 
# ranked_data assumed to be 2 col df with gene symbol and enrichment score titled symbol and score 
plotRank <- function(ranked_data, save, genes_of_interest = NULL, 
                     textsize = 0.8, pad = 2, pointsize = 1, highlight = 30, 
                     title = "Rank Plot", yaxis = "meandiff", number_show = 10, num_score_thres = 0.5){
  
  library(plyr)
  library(ggrepel)
  library(ggplot2)

  # Define gene names of interest if none provided

  if (is.null(genes_of_interest)){

    genes_of_interest <- c(head(ranked_data$symbol, (number_show/2)), tail(ranked_data$symbol, (number_show/2)))
    
    genes_of_interest <- genes_of_interest[!is.na(genes_of_interest)]
  }

  # Define state column for plotting of colour points and labelled points

  ranked_data$state = rep(FALSE,length(rownames(ranked_data)))

  ranked_data$state = ifelse(ranked_data$rank %in% 1:highlight | ranked_data$rank %in% (length(ranked_data$rank)-highlight):length(ranked_data$rank), "Yes", "No")

  # This will also pick up DMRs with associated genes that are not unique (multiple peaks per gene if they are within the top hits)
  ranked_data$state = ifelse(ranked_data$symbol %in% genes_of_interest & abs(ranked_data$score) > num_score_thres, "Highlight", ranked_data$state)
  
  # Write out underlying CSV file of rank in case required downstream

  write.table(as.data.frame(ranked_data), file = save, quote = F, sep = "\t", row.names = FALSE)

  # Ggplot obj

  num_highlight <- round(min(number_show, nrow(ranked_data[ranked_data$state == "Highlight",]))/2)
  highlight_df <- rbind.data.frame(head(ranked_data[ranked_data$state == "Highlight",], num_highlight), tail(ranked_data[ranked_data$state == "Highlight",], num_highlight))
                        
  p = ggplot(ranked_data, aes(rank, score)) +
        geom_point(aes(col=state), size = pointsize, alpha = 0.5) + 
        geom_point(data = subset(ranked_data, state %in% c('Yes')), aes(col = state), size = pointsize, alpha = 0.05) + 
        geom_point(data = subset(ranked_data, state %in% c("Highlight")), aes(col = state), size = pointsize, alpha = 0.5) +
        scale_color_manual(values = c("#f05b5b", "#828282", "#5b88f0"), guide = FALSE) +
        geom_text_repel(data = highlight_df, aes(label = symbol), size = textsize, point.padding = pad) + 
        geom_rect(data = head(ranked_data, 1), aes(ymin=-num_score_thres, ymax=num_score_thres, xmin=-Inf, xmax=Inf), alpha= 0.5) +
        geom_hline(yintercept = 0, linetype="solid", color = "black", size=0.5, alpha= 0.5) + 
        geom_hline(yintercept = -num_score_thres, linetype="dashed", color = "black", size=0.5, alpha= 0.5) + 
        geom_hline(yintercept = num_score_thres, linetype="dashed", color = "black", size=0.5, alpha= 0.5) + 
        ggtitle(title) + 
        labs(y = yaxis, x = "Rank") + 
        theme_classic() + 
        theme(plot.title = element_text(hjust = 0.5, size=rel(1.6)) ,
              axis.text.x = element_text(angle = 45, vjust = 1, hjust=1, size=rel(1.6)), 
              axis.title.x = element_text(size=rel(1.6)),
              axis.text.y = element_text(size=rel(1.6)),
              axis.title.y = element_text(size=rel(1.6)))
  
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
  library(DMRcate)

  results <- readRDS(input$rds)
  
  # Define params for rank plot function
  # note dmrcate results file for ranking is names meandiff (in the past it was meanbetafc)
  save <- output$tsv
  genes_of_interest <- params$genes_of_interest
  width <- params$width
  height <- params$height
  textsize <- params$textsize
  pad <- params$pad
  pointsize <- params$pointsize
  highlight <- params$highlight
  title <- params$title
  yaxis <- params$yaxis
  number_show <- params$number_show
  num_score_thres <- params$num_score_thres

  symbol <- params$symbol # overlapping.genes

  # Run prep results table 
  ranked_data <- prepRes(results, yaxis, symbol = symbol)

  # Plot rank plot
  p <- plotRank(ranked_data, save, genes_of_interest,
                     textsize, pad, pointsize, highlight, 
                     title, yaxis, number_show, num_score_thres)
  
  ggsave(output$pdf, plot = p, width = width,  height = height)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
