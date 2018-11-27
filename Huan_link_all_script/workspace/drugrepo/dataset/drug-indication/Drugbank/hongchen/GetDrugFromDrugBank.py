# -*- coding: utf-8 -*-
"""
Created on Sun Jun 05 19:08:32 2016

@author: Admin
"""

# -*- coding: UTF-8 -*-


#==============================================================================
# import sys
# #在sys加载后，setdefaultencoding方法被删除了，所以要重新导入sys来设置系统编码
# reload(sys)
# sys.setdefaultencoding('utf-8')
#==============================================================================

#import cElementTree which is faster
import xml.etree.cElementTree as ET
#import time for the computation of program running time
import time
import codecs
import csv
import re


def byteify(input):
    if isinstance(input, dict):
        return {byteify(key):byteify(value) for key,value in input.iteritems()}
    elif isinstance(input, list):
        return [byteify(element) for element in input]
    elif isinstance(input, unicode):
        return input.encode('utf-8')
    else:
        return input 

def level_prioritize(level_list):
    if 'approved' in level_list:
        highest_level = 'Approved'
    elif 'illicit' in level_list:
        highest_level = 'Illicit'
    elif 'nutraceutical' in level_list:
        highest_level = 'Nutraceutical'
    elif 'vet_approved' in level_list:
        highest_level = 'Vet Approved'
    elif 'investigational' in level_list:
        highest_level = 'Clinical Trials'
    elif 'experimental' in level_list:
        highest_level = 'Experimental'
    elif 'withdrawn' in level_list:
        highest_level = 'Withdrawn'
    return highest_level
        


#record the beginning of the program
start = time.time()

f_output = open('Drug_Claim_Drugbank_2016_06_28.csv', 'wb')

header = ['Drug_Name', 'Drug_Type', 'Drug_Level', 'Drug_Indication', 'Drug_Side_effect', 'Cancer_Prescribed', 'Tumor_Type', \
'Drug_Source_ID', 'Drug_Source', 'Source_Database']

#write the headers first
csvWriter = csv.writer(f_output, dialect = 'excel')
csvWriter.writerow(header)


f_input = open('drugbank_4.xml', 'r')

#there are many ways for parse, see the eTree doc
eTree = ET.parse(f_input)

#eTree is special, it can be accessed like a list, by doesn't look like 
drugbank = eTree.getroot()
drugs = list(drugbank)


#iterate and write every line
for drug in drugs:
   
    #get drug name
    name = drug.find('{http://www.drugbank.ca}name').text
    
    #get drug type
    drug_type = drug.get('type')
    #get drug level
    levels = drug.find('{http://www.drugbank.ca}groups')
    level_all = []
    for level in levels:
        level_all.append(level.text)
    best_level = level_prioritize(level_all)

    #get the drug indication, if drug.find can't find the indication,it will return None to indication,thus making indication a nonetype
    indication = drug.find('{http://www.drugbank.ca}indication').text
    # some items do not have indication
    if indication == None:
        indication = "N/A"
    indication = indication.replace('\n', '')
    indication = indication.replace('\r', '')
    
    #get the side effect
    side_effect = drug.find("{http://www.drugbank.ca}toxicity").text
    if side_effect == None:
        side_effect = "N/A"
    side_effect = side_effect.replace('\n', '')
    side_effect = side_effect.replace('\r', '')

    #get the drug atc codes
    atc_codes = drug.find('{http://www.drugbank.ca}atc-codes')
    atc_code_all = ''
    # some items do not have atc_code
    if atc_codes.findall('{http://www.drugbank.ca}atc-code') == []:
        atc_code_all = "N/A"
    else:
        for atc_code in atc_codes:
            for atc_level in atc_code:
                atc_code_all = atc_code_all + atc_level.text + ','
    if re.search('ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS', atc_code_all, re.I):
        cancer_prescribed = 'Yes'
    else:
        cancer_prescribed = 'N/A'
    
    tumor_type = 'N/A' 
    
    #get the drugbank id as the source
    drugbank_id = drug.find("{http://www.drugbank.ca}drugbank-id").text
    source = "http://www.drugbank.ca/drugs/" + drugbank_id
    source_id = drugbank_id
    source_database = 'Drugbank'
    Row = [name, drug_type, best_level, indication, side_effect, cancer_prescribed, tumor_type, source_id, source, source_database]
    STDRow = byteify(Row)
    csvWriter.writerow(STDRow)

    
#record the end of the program
end = time.time()
#compute the time spent
time_spend = end - start

f_output.close()
f_input.close()

print time_spend
