library(tidyverse)
library(DESeq2)
library(stringr)
b27count <- read_delim("b27.rawcount.txt")
setwd("compare/") #directory of files contain compare group
# for example: call DEGs of KN199-0h and PEG-KN199-1h
# wt0wt1.txt
# KN199-0h-1
# KN199-0h-2
# KN199-0h-3
# PEG-KN199-1h-1
# PEG-KN199-1h-2
# PEG-KN199-1h-3

for (file in list.files()) {
  group <- read.table(file)
  count <- b27count %>% select(Geneid, group$V1)
  tpm <- b27tpm %>% select(Geneid, group$V1)
  count <- count %>% select(-1)
  rownames(count) <- b27count$Geneid
  group$V1 <- str_sub(group$V1, 1, -3)
  group$V1 <- factor(group$V1,levels=unique(group$V1))
  dds <- DESeqDataSetFromMatrix(countData = count, colData = group, design = ~ V1)
  deg <- DESeq(dds)
  res <- results(deg)
  result <- as.data.frame(res)
  #result <- subset(result,abs(log2FoldChange)>0.58 & padj<0.05)  
  up=subset(result,log2FoldChange > 0.58 & padj<0.05)
  down=subset(result,log2FoldChange < -0.58 & padj<0.05)
  print("deseq done")
  deg_file_name <- paste0(file, ".deg.txt")
  up_file_name <- paste0(file, ".up.txt")
  down_file_name <- paste0(file, ".down.txt")
  write.table(result, file = deg_file_name, sep = "\t", quote = FALSE,row.names = T,col.names = T) # write all DESeq2 result
  write.table(rownames(up), file = up_file_name, sep = "\t", quote = FALSE,row.names = F,col.names = F) # write up regulated DEGs 
  write.table(rownames(down), file = down_file_name, sep = "\t", quote = FALSE,row.names = F,col.names = F)  # write down regulated DEGs 
}
sessionInfo()
