# coding: utf-8
import pandas as pd
import numpy as np
import vcf
import sys

vcf_reader=vcf.Reader(open('./simple_somatic_mutation.aggregated' + '.vcf.gz','r'))

out_file  = open('./simple_somatic_mutation.aggregated' + '.txt','w')

ith_line = 0
for record in vcf_reader:
    ith_line = ith_line + 1
    # try:
    #     CHROM=str(record.CHROM)
    #     POS=str(record.POS)
    #     REF=str(record.REF)
    #     ALT=str(record.ALT)
    #     ID = str (record.ID)
    #     tmp = record.INFO['OCCURRENCE']
    #     value_tmp = tmp[0].split('|')
    #     disease = str(value_tmp[0])
    #     occurrence = str(value_tmp[1])
    #     tested_donors = str(value_tmp[2])
    #     frequency = str(value_tmp[3])
    # except:
    #      continue
    # out_str = CHROM+'\t'+POS+'\t'+REF+'\t'+ALT+'\t'+ID +'\t'+ disease+'\t'+occurrence+'\t'+tested_donors+'\t'+ frequency+'\n'
    # out_file.write(out_str)

    print record
    if ith_line == 6:
        break

out_file.close()
        

