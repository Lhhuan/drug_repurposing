library(limma)
info_gene_raw=read.csv('GSE92742_Broad_LINCS_gene_info.txt',sep='\t',header=T)
info_gene=info_gene_raw[,1:2]
filenames=list.files('drug_DMSO_1')
for (filename in filenames){
  info_file=strsplit(filename,'_')
  nsample_drug=as.numeric(info_file[[1]][2])
  nsample_dmso=as.numeric(info_file[[1]][4])
  nsample=nsample_dmso+nsample_drug
  samps<-factor(c(rep("case",nsample_drug),rep("control",nsample_dmso)))
  design <- model.matrix(~0+samps)
  colnames(design) <- c("case","control")
  raw_data=read.csv(paste('drug_DMSO_1/',filename,sep=''),header = T,sep='\t')
  raw_data=merge(raw_data,info_gene,by.x = 'rid',by.y='pr_gene_id')
  raw_data=raw_data[,-1]
  rownames(raw_data)=raw_data[,(nsample+1)]
  raw_data=raw_data[,-(nsample+1)]
  rownames(design)=colnames(raw_data)
  fit <- lmFit(raw_data, design)
  
  cont.matrix<-makeContrasts(control-case,levels=design)
  fit2 <- contrasts.fit(fit, cont.matrix)
  fit2 <- eBayes(fit2)
  result<-topTable(fit2,n=Inf)
  
  filter_res_p<-result[result$P.Value<0.05,]
  filter_res_adjp<-result[result$adj.P.Val<0.05,]
  write.table(filter_res_p,file=paste('drug_DMSO_limma_p/limma_',filename,sep=''),quote=F,row.names = T,sep='\t')
  write.table(filter_res_adjp,file=paste('drug_DMSO_limma_adj/limma_',filename,sep=''),quote=F,row.names = T,sep='\t')
  
  }
