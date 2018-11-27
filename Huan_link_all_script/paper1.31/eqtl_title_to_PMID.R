library(readxl)
library(dplyr)
library(stringr)



title1 <- read.table("~/project/qtl_tool/eqtl/01_eqtl_title_to_PMID.txt",header = T)
title2 <- read.table("~/project/qtl_tool/eqtl/title/02/02_eqtl_title_to_PMID.txt",header = T)
title3 <- read.table("~/project/qtl_tool/eqtl/title/03_jou/03_eqtl_title_to_PMID.txt",header = T)
title4_01 <- read.table("~/project/qtl_tool/eqtl/title/04_jou/04_eqtl_title_to_PMID.txt",header = T)
title4_02 <- read.table("~/project/qtl_tool/eqtl/title/04_jou/04_2_eqtl_title_to_PMID.txt",header = T)
title4_03 <- read.table("~/project/qtl_tool/eqtl/title/04_jou/04_3_eqtl_title_to_PMID.txt",header = T)
title4 <- bind_rows(title4_01,title4_02,title4_03)
title5_01 <- read.table("~/project/qtl_tool/eqtl/title/05_jou/01_eqtl_title_to_PMID.txt",header = T)
title5_02 <- read.table("~/project/qtl_tool/eqtl/title/05_jou/02_eqtl_title_to_PMID.txt",header = T)
title5_03 <- read.table("~/project/qtl_tool/eqtl/title/05_jou/03_eqtl_title_to_PMID.txt",header = T)
title5 <- bind_rows(title5_01,title5_02,title5_03)


eqtl_title <- bind_rows(title2,title3,title4,title5,title1)%>%unique()


setwd ("~/project/qtl_tool/eqtl")
write.table(eqtl_title,'eqtl_title_to_PMID.txt',row.names = F, col.names = T)
