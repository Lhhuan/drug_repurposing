info_gene_raw=read.csv('GSE92742_Broad_LINCS_gene_info.txt',sep='\t',header=T)
info_gene=info_gene_raw[,1:2]
filenames=list.files('drug_DMSO_1')
for (filename in filenames){
  cat(filename)
  info_file=strsplit(filename,'_')
  nsample_drug=as.numeric(info_file[[1]][2])
  nsample_dmso=as.numeric(info_file[[1]][4])
  nsample=nsample_dmso+nsample_drug
  
  raw_data=read.csv(paste('drug_DMSO_1/',filename,sep=''),header = T,sep='\t')
  raw_data=merge(raw_data,info_gene,by.x = 'rid',by.y='pr_gene_id')
  raw_data=raw_data[,-1]
  rownames(raw_data)=raw_data[,(nsample+1)]
  raw_data=raw_data[,-(nsample+1)]
  p=apply(raw_data,1,function(x){wilcox.test(x[1:nsample_drug],x[(1+nsample_drug):nsample],exact = F)$p.value})
  z=apply(raw_data,1,function(x){mean(x[(1+nsample_drug):nsample])-mean(x[1:nsample_drug])})
  FDR=p.adjust(p,method = 'BH')
  re=data.frame(gene=rownames(raw_data),p,FDR,z)
  
  re_filter=re[re$p<0.05,]
  write.table(re_filter,file=paste('drug_DMSO_diff/diff_',filename,sep=''),quote=F,row.names = F,sep='\t')
}

