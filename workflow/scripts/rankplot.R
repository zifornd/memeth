
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
plotRank <- function(ranked_data, save, genes_of_interest = NULL, 
                     width = 5, height = 5, textsize = 0.8, pad = 2, pointsize = 1, 
                     title = "Rank Plot", yaxis = "meandiff", number_show = 10, num_score_thres = 0.5){
  
  # data_table_spec, genes_of_interest, plot_out, save,
  #                    width, height, size, pad, pointsize, title, yaxis, 
  #                    number_show, num_Score_thres

  ##### https://stackoverflow.com/questions/15706281/controlling-order-of-points-in-ggplot2-in-r
  #ggplot(df) + geom_point(aes(x = x, y = y, color = label, size = size)) +
  #  geom_point(aes(x = x, y = y, color = label, size = size), 
  #             subset = .(label == 'point'))

  library(plyr)
  library(ggrepel)
  library(ggplot2)

  # Define gene names of interest if none provided

  if (!is.null(genes_of_interest)){

    genes_of_interest <- c(head(ranked_data, (number_show/2)), tail(ranked_data, (number_show/2)))
    
  }

  # Define state column for plotting of colour points and labelled points

  ranked_data$state = rep(FALSE,length(rownames(ranked_data)))

  ranked_data$state = ifelse(ranked_data$rank %in% 1:20 | ranked_data$rank %in% (length(ranked_data$rank)-20):length(ranked_data$rank), "Yes", "No")
  ranked_data$state = ifelse(ranked_data$symbol %in% genes_of_interest & abs(ranked_data$score) > num_score_thres, "Highlight", ranked_data$state)
  
  # Write out underlying CSV file of rank in case required downstream

  write.csv(as.data.frame(ranked_data), file = save, quote = F)
  
  print(head(ranked_data, 25))
  print(tail(ranked_data, 25))
  print(subset(ranked_data, state == 'Yes'))
  # pdf(paste0(plot_out,save,".pdf"), width, height, useDingbats=FALSE)
  
  # Ggplot obj

  p = ggplot(ranked_data, aes(rank, score)) +
    geom_point(aes(col=state), size=pointsize, alpha=0.5) + 
    geom_point(data = subset(ranked_data, state %in% c('Yes')), aes(col=state), size=pointsize, alpha=0.05) + 
    geom_point(data = subset(ranked_data, state %in% c("Highlight")), aes(col=state), size=pointsize, alpha=0.5) +
    scale_color_manual(values=c("#5b88f0", "#828282", "#303030"), guide = FALSE) +
    geom_text_repel(data=rbind.data.frame(head(ranked_data[ranked_data$state == "Highlight",],number_show)), aes(label=symbol), 
                    size = textsize, point.padding = pad) + theme_classic()+ 
    ggtitle(title) + 
    labs(y = yaxis, x = "Rank") +theme_classic()+theme(plot.title = element_text(hjust = 0.5, size=rel(2)) , 
                               axis.text.x=element_text(size=rel(2),hjust=1 ) , 
                               axis.title.x = element_text(size=rel(2)),
                               axis.text.y=element_text(size=rel(2)),
                               axis.title.y = element_text(size=rel(2)))
  
  
  # plot(p+theme_classic()+theme(plot.title = element_text(hjust = 0.5, size=rel(2)) , 
  #                              axis.text.x=element_text(size=rel(2),hjust=1 ) , 
  #                              axis.title.x = element_text(size=rel(2)),
  #                              axis.text.y=element_text(size=rel(2)),
  #                              axis.title.y = element_text(size=rel(2)))) 
  
  

  # dev.off()
  
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
  save <- output$csv
  genes_of_interest <- params$genes_of_interest
  width <- params$width
  height <- params$height
  textsize <- params$textsize
  pad <- params$pad
  pointsize <- params$pointsize
  title <- params$title
  yaxis <- params$yaxis
  number_show <- params$number_show
  num_score_thres <- params$num_score_thres

  print(class(params$testo))
  print(params$testo)

  # Run prep results table 
  ranked_data <- prepRes(results, yaxis)

  print(head(ranked_data))
  # Plot rank plot
  p <- plotRank(ranked_data, save, genes_of_interest,
                     width, height, textsize, pad, pointsize, title, yaxis, 
                     number_show, num_score_thres)
  
  ggsave(output$pdf, plot = p)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
