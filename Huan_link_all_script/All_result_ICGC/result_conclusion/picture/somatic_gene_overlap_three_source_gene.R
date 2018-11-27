library(VennDiagram)
library(dplyr)

setwd("~/All_result_ICGC/result_conclusion/picture")
f1<-read_tsv("/f/mulinlab/huan/All_result_ICGC/three_source_cancer_gene.txt",col_names = F)
f2<-read_tsv("/f/mulinlab/huan/All_result_ICGC/ICGC_occurthan1_snv_indel_mutationID_ensg_entrez.txt",col_names = TRUE)
ICGC_snv_indel<-f2$Gene%>%unique()
three_source_gene<-f1$X2


T<-venn.diagram(list(ICGC_snv_indel_gene=ICGC_snv_indel,report_and_predict_cancer_gene=three_source_gene),filename=NULL
                ,lwd=1,lty=2,col=c('#6495ED','#5CACEE')
                ,fill=c('#6495ED','#5CACEE')
                ,cat.col=c('#6495ED','#5CACEE')
                ,reverse=TRUE)
grid.draw(T)


