import pandas as pd
import numpy as np
import vcf
import sys

#chr_id = sys.argv[1]
vcf_reader=vcf.Reader(open('./simple_somatic_mutation.aggregated' + '.vcf.gz','r'))

out_file  = open('./simple_somatic_mutation.aggregated' + '.txt','w')

for record in vcf_reader:
    tmp = record.INFO['OCCURRENCE']
    #print type(tmp[0])
    value_tmp = tmp[0].split('|')
    #print type(float(value_tmp[3]))
    ID = str (record.ID)
    print type(ID)
    break
    # CHROM=str(record.CHROM)
    # POS=str(record.POS)
    # ID = str (record.ID)
    # REF=str(record.REF)
    # ALT=str(record.ALT)
    # INFO = str(record.INFO)
    # out_str = CHROM +'\t' + POS + '\t' + REF + '\t' + ALT + '\t' + ID + '\t' +INFO + '\n'
    out_file.write(out_str)
out_file.close()