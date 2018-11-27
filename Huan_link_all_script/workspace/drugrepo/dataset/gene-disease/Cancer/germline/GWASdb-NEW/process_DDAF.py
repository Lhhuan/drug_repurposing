
# coding: utf-8

# In[1]:

import pandas as pd
import numpy as np
import vcf
import sys

# In[93]:

is_debug = False
vcf_reader=vcf.Reader(open('/f/mulinlab/ref_data/gnomad/gnomad.genomes.r2.0.1.sites.' + sys.argv[1] + '.vcf.gz','r'))
if is_debug:
    vcf_record_num = 100

# In[94]:

#pds_res = pd.Series()
pds_chrom = pd.Series() # for string
pds_pos = pd.Series()
pds_id = pd.Series()
pds_ref= pd.Series()
pds_alt= pd.Series()
pds_csq= pd.Series()


ith_record = 0
ith_vcf = 0
ith_subfile =  0
error_record = 0
for record in vcf_reader:
    CSQ = record.INFO['CSQ']
    ALT = record.ALT
    
#     print AF_EAS, AF_AFR, AF_ASJ, AF_FIN, AF_NFE, AF_OTH, ALT
    
    chrom = str(record.CHROM)
    pos = str(record.POS)
    ID = str(record.ID)
    ref = str(record.REF)
    # print 'csq~~~' + str(CSQ) 
    # print 'ALT~~~' + ALT 
    # print 'chrom~~~' + chrom
    # print pos
    # print ID
    # print ref
    # print '~~~'
    if ID =='None':
        continue
    
    ith_record = ith_record + 1
    # pds_res = pds_res.append(pd.Series((A+B+C+D+E)/5 - DS))
            
    pds_chrom = pds_chrom.append(pd.Series(chrom))
    pds_pos = pds_pos.append(pd.Series(pos))
    pds_id = pds_id.append(pd.Series(ID))
    pds_ref = pds_ref.append(pd.Series(ref))
    pds_alt = pds_alt.append(pd.Series(ALT))
    pds_csq = pds_alt.append(pd.Series(CSQ))

    if ith_record%3 == 0:
        df_res  = pd.DataFrame({
                    'CHROM':pds_chrom,
                    'POS':pds_pos,
                    'ID':pds_id,
                    'REF':pds_ref,
                    'ALT':pds_alt,
                    'CSQ':pds_csq
                })
        df_res.to_csv('./gnome/res_'+sys.argv[1]+'_'+str(ith_subfile)+'.csv', index=False)
        break
        pds_chrom = pd.Series() # for string
        pds_pos = pd.Series()
        pds_id = pd.Series()
        pds_ref = pd.Series()
        pds_alt = pd.Series()
        pds_csq= pd.Series()

    ith_subfile = ith_subfile + 1

df_res  = pd.DataFrame({
    'CHROM':pds_chrom,
    'POS':pds_pos,
    'ID':pds_id,
    'REF':pds_ref,
    'ALT':pds_alt,
    'CSQ':pds_csq
})


# In[99]:

df_res.to_csv('./gnome/res_'+sys.argv[1]+'_'+str(ith_subfile)+'.csv', index=False)





