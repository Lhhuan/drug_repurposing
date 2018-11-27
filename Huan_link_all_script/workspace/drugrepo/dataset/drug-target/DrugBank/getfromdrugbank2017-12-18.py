
# coding: utf-8

# In[4]:



# In[118]:


import xml.etree.cElementTree as ET
import time
import codecs
import csv
import re

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

# In[119]:

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


# In[5]:

f_input = open('./full_database.xml', 'r')

#there are many ways for parse, see the eTree doc
eTree = ET.parse(f_input)
#eTree is special, it can be accessed like a list, by doesn't look like 
drugbank = eTree.getroot()
drugs = list(drugbank)


# In[7]:

out_file = open('./getfromdrugbank2017-12-18.txt', 'w')
#out_file.write(header_str)
for drug in drugs:
    name = drug.find('{http://www.drugbank.ca}name').text
    #print name
    cas_number = drug.find('{http://www.drugbank.ca}cas-number').text
    if  cas_number == None:
         cas_number = "NA"
    cas_number = cas_number.replace('\n', '')
    cas_number = cas_number.replace('\r', '')
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
        indication = "NA"
    indication = indication.replace('\n', '')
    indication = indication.replace('\r', '')
    
    #get the side effect
    side_effect = drug.find("{http://www.drugbank.ca}toxicity").text
    if side_effect == None:
        side_effect = "NA"
    side_effect = side_effect.replace('\n', '')
    side_effect = side_effect.replace('\r', '')

    #get the drug atc codes
    atc_codes = drug.find('{http://www.drugbank.ca}atc-codes')
    atc_code_all = ''
    # some items do not have atc_code
    if atc_codes.findall('{http://www.drugbank.ca}atc-code') == []:
        atc_code_all = "NA"
    else:
        for atc_code in atc_codes:
            for atc_level in atc_code:
                atc_code_all = atc_code_all + atc_level.text + ','
    if re.search('ANTINEOPLASTIC AND IMMUNOMODULATING AGENTS', atc_code_all, re.I):
        cancer_prescribed = 'Yes'
    else:
        cancer_prescribed = 'NA'
    
    tumor_type = 'NA' 
    
    #get the drugbank id as the source
    drugbank_id = drug.find("{http://www.drugbank.ca}drugbank-id").text
    source = "http://www.drugbank.ca/drugs/" + drugbank_id
    source_id = drugbank_id
    source_database = 'Drugbank'
    #print target_name + action_text + tumor_type + source_id
    #break
    
    identifiers = drug.find('{http://www.drugbank.ca}external-identifiers')
    if (len(list(identifiers)) ==0):
        chemle_id = 'NA'
    else:
        for iden in identifiers:
            if iden[0].text == 'ChEMBL':
                chemle_id = iden[1].text
                break
            else:
                chemle_id = 'NA'
            
    
        #print chemle_id   
    #print len(list(targets))
    targets = drug.find('{http://www.drugbank.ca}targets')
    if (len(list(targets)) ==0):
        target_name = 'NA'
        action_text = 'NA'
        polypeptide_id = "NA"
        #print action_text
        header_str = name+'\t'+cas_number+'\t'+target_name+'\t'+polypeptide_id+'\t'+action_text+'\t'
        header_str = header_str + drug_type+'\t'+best_level+'\t'+indication+'\t'+side_effect+'\t'+cancer_prescribed+'\t'+tumor_type+'\t'
        header_str = header_str +source_id+ '\t'+source+'\t'+source_database+'\t'+ chemle_id +'\n'
        #header_str = source_id+ '\t'+ chemle_id +'\n'
        #print header_str
        out_file.write(header_str)
        #print target_name
        #print action1
        #print '1234567890'
    else:
        for target in targets:
            #print len(target)
            if len(target) < 7:
                polypeptide_id = "NA"
                #print polypeptide_id
            else:
                polypeptide_id = target[6].get('id')
                #print polypeptide_id
                #print '123~~~~~~~~~~~~~~~~~~~~~~'
            target_name =  target[1].text
            #print target_name
            actions =target[3]
            if (len(list(actions))) == 0:
                action_text = 'na'
                #print action_text
                #print '12345676789'
            else:
                for action in actions:
                    action_text = action.text
            header_str = name+'\t'+cas_number+'\t'+target_name+'\t'+polypeptide_id+'\t'+action_text+'\t'
            header_str = header_str + drug_type+'\t'+best_level+'\t'+indication+'\t'+side_effect+'\t'+cancer_prescribed+'\t'+tumor_type+'\t'
            header_str = header_str + source_id+ '\t'+source+'\t'+source_database+'\t'+ chemle_id +'\n'
            #header_str = source_id+ '\t'+ chemle_id +'\n'
            out_file.write(header_str)
            #out_file.write(header_str)+
            #print header_str
out_file.close()   


# In[ ]:



