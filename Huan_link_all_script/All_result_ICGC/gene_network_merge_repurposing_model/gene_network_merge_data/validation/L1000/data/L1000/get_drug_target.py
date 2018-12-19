files_list='/home/cuihui/L1000/drug_DMSO_limma_adj/limma_A549_24_list'
nur_target_file='/home/cuihui/motif/10_PIQ_output/PIQ_call/A549/nur_target.txt'
nur_target={}
with open(nur_target_file) as f:
    for line in f:
        ls1=line.strip().split('\t')
        if '.RC' in line:
            nur=ls1[0].strip('.RC')
        else:
            nur=ls1[0]
        if nur in nur_target:
            nur_target[nur]=nur_target[nur]+';'+ls1[1]
        else:
            nur_target[nur]=ls1[1]
f.close()
drug_target={}
with open('L1000_drug_target.txt') as f:
    for line in f:
        ls1=line.split('\t')
 
        drug_target[ls1[0]]=ls1[1]
f.close()
output=open('limma_p_A549_24.txt','w')
with open(files_list) as f:
    for line in f:
        if 'total' in line:
            continue
        ls1=line.strip().split()
        filenames=ls1[1]
        print filenames
        drug=filenames.split('_')[1].upper()
        with open('/home/cuihui/L1000/drug_DMSO_limma_p/'+filenames) as f1:
             for line in f1:
                 ls1=line.split('\t')
                 if 'logFC' in line:
                    continue
                 if float(ls1[1])>0:
                     prop='up'
                 if float(ls1[1])<0:
                     prop='down'
                 
                 if ls1[0] in nur_target[drug_target[drug].strip()]:
                     output.write(drug+'\t'+drug_target[drug].strip()+'\t'+ls1[0]+'\t'+prop+'\n')     
        
        f1.close()
f.close()
output.close()
