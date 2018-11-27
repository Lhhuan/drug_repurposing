# coding: utf-8
import pandas as pd
import numpy as np
import vcf
import sys

#chr_id = sys.argv[1]
vcf_reader=vcf.Reader(open('./simple_somatic_mutation.aggregated' + '.vcf.gz','r'))

out_file  = open('./simple_somatic_mutation.aggregated' + '.bed','w')

for record in vcf_reader:
    try:
        CHROM=str(record.CHROM)
        POS=str(record.POS)
        ID = str (record.ID)
        REF=str(record.REF)
        ALT=str(record.ALT)

    #     if len(REF)==1 and len(ALT) == 3:
    #         out_str = CHROM +'\t' + str(int(POS)-1) + '\t' + POS + '\t' + REF + '\t' + ALT[1] +'\n'
    #         out_file.write(out_str)
    except:
        continue
    out_str = CHROM +'\t' + POS + '\t' + REF + '\t' + ALT + '\t' + ID + '\n'
    out_file.write(out_str)
out_file.close()