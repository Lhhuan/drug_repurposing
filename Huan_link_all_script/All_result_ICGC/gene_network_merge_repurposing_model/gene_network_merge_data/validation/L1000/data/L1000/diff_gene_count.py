import os
gene={}
for file in os.listdir('./drug_DMSO_diff'):
    with open('./drug_DMSO_diff/'+file) as f:
        for line in f:
            ls1=line.split('\t')
            gene[ls1[0]]=''
        f.close()

output=open('diff_gene_count.txt','w')
for key in gene:
    output.write(key+'\n')
output.close()
