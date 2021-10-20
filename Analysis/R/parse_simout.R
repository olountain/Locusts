library(tidyverse)

tmp <- read_tsv("simout/rep43/job-fa0.01-fr0.1-fal1-active2700-pause900-rproba0.001-occlu25-jumpD0-replicat43.simout", skip = 1)



tmp2 <- tmp %>%
    filter(PARAM == "GRID") %>% 
    filter(`524288` == max(tmp$`524288`, na.rm = T))

tmp2 <- tmp2[,3:4]
colnames(tmp2) <- c("hex", "count")
tmp2

