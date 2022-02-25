
# Author: James Ashmore, Ben Southgate
# Copyright: Copyright 2020, James Ashmore, Ben Southgate
# Email: james.ashmore@zifornd.com ben.southgate@zifornd.com
# License: MIT


plot_rank <- function(data_table_spec, genes_of_interest, plot_out, save, width, height, size, pad, pointsize, title, yaxis, number_show, num_Score_thres){
  
  ##### https://stackoverflow.com/questions/15706281/controlling-order-of-points-in-ggplot2-in-r
  #ggplot(df) + geom_point(aes(x = x, y = y, color = label, size = size)) +
  #  geom_point(aes(x = x, y = y, color = label, size = size), 
  #             subset = .(label == 'point'))
  library(plyr)
  library(ggrepel)
  library(ggplot2)
  
  colnames(data_table_spec) = c("symbol","score")
  
  ranked_data = data_table_spec[order(-data_table_spec$score),]
  ranked_data$rank = rep(1:length(ranked_data$score))
  
  #### Z score plots  
  
  ranked_data$state = rep(FALSE,length(rownames(ranked_data)))

  ranked_data$state = ifelse(ranked_data$rank %in% 1:20 | ranked_data$rank %in% (length(ranked_data$rank)-20):length(ranked_data$rank), "Yes", "No")
  ranked_data$state = ifelse(ranked_data$symbol %in% genes_of_interest & abs(ranked_data$score) > num_Score_thres, "Highlight", ranked_data$state)
  
  write.csv(ranked_data, paste0(plot_out,save,".csv"))
  
  print(head(ranked_data, 25))
  print(tail(ranked_data, 25))
  print(subset(ranked_data, state == 'Yes'))
  pdf(paste0(plot_out,save,".pdf"), width, height, useDingbats=FALSE)
  
  
  p = ggplot(ranked_data, aes(rank, score)) +
    geom_point(aes(col=state), size=pointsize, alpha=0.5) + 
    geom_point(data = subset(ranked_data, state %in% c('Yes')), aes(col=state), size=pointsize, alpha=0.05) + 
    geom_point(data = subset(ranked_data, state %in% c("Highlight")), aes(col=state), size=pointsize, alpha=0.5) +
    scale_color_manual(values=c("#5b88f0", "#828282", "#303030"), guide = FALSE) +
    geom_text_repel(data=rbind.data.frame(head(ranked_data[ranked_data$state == "Highlight",],number_show)), aes(label=symbol), size = size, point.padding = pad) + theme_classic()+ 
    ggtitle(title) + 
    labs(y = yaxis, x = "Rank")
  
  
  plot(p+theme_classic()+theme(plot.title = element_text(hjust = 0.5, size=rel(2)) , 
                               axis.text.x=element_text(size=rel(2),hjust=1 ) , 
                               axis.title.x = element_text(size=rel(2)),
                               axis.text.y=element_text(size=rel(2)),
                               axis.title.y = element_text(size=rel(2)))) 
  
  
  #}
  dev.off()
  
  
  
  
}


.libPaths(new = "resources/bioconductor/platform/lib/R/library")

main <- function(input, output, params, log) {
  
  # Log
  
  out <- file(log$out, open = "wt")
  
  err <- file(log$err, open = "wt")
  
  sink(out, type = "output")
  
  sink(err, type = "message")
  
  # Script
  
  library(minfi)
  library(params$platform, character.only = TRUE)
  
  results <- readRDS(input$rds)
  
  # note dmrcate results file for ranking is names meanbetafc
  
  p <- plot_rank(getBeta)
  
  ggsave(output$pdf, plot = p)
  
}

main(snakemake@input, snakemake@output, snakemake@params, snakemake@log)
