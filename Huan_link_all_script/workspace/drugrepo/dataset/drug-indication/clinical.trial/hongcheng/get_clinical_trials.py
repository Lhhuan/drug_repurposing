# -*- coding: utf-8 -*-
"""
Created on Tue Jun 14 12:29:42 2016

@author: Admin
"""

import csv
import re

#the format of clinical trial is special, this is to remove some annoying EOF symbols
def records(path):
    with open(path, 'rb') as f:
        contents = f.read()
        contents = contents.replace('\n', '')
        contents = contents.split('\r')
        contents = contents[:-1]
        return (record for record in contents)

def merge_dict(path, *cols):
    csvreader_merge = csv.reader(records(path), delimiter = '|', quoting = csv.QUOTE_NONE)
    merging_dict = {}
    if len(cols) == 2:
        for row in csvreader_merge:
            if row[cols[0]] in merging_dict:
                merging_dict[row[cols[0]]] = merging_dict[row[cols[0]]] + ',' + row[cols[1]]
            else:
                merging_dict[row[cols[0]]] = row[cols[1]]
    elif len(cols) == 3:
        for row in csvreader_merge:
            if row[cols[0]] in merging_dict:
                merging_dict[row[cols[0]]] = merging_dict[row[cols[0]]] + ';   ' + row[cols[1]] + ': ' + row[cols[2]]
            else:
                merging_dict[row[cols[0]]] = row[cols[1]] + ': ' + row[cols[2]]
    return merging_dict

output_file = open('Clinical_Trial_Claim_2016_07_01.tsv', 'wb')
 
csvreader = csv.reader(records('clinical_study_noclob.txt'), delimiter = '|', quoting = csv.QUOTE_NONE)
csvwriter = csv.writer(output_file, dialect = 'excel-tab')

intervention_dict = merge_dict('interventions.txt', 1, 2, 3)
condition_dict = merge_dict('conditions.txt', 1, 2)
condition_mesh_dict = merge_dict('condition_browse.txt', 1, 2)

header = ['Drug_Name', 'Related_Disease', 'Disease_MeSH_Term', 'Cancer_Related', 'Title', 'Phase', 'Trial_Source_ID', 'Trial_Source', 'For Ranking']
csvwriter.writerow(header)
cancer_mesh_list = r'Neoplasms|Neoplasm|Cancers|Cancer|Neoplasia|Tumors|Tumor|Carcinoma|Melanoma|Sarcoma'
mesh_pattern = re.compile(cancer_mesh_list, re.I)
n = 1
for old_row in csvreader:
    if n == 1:
        n += 1
        continue
    else:
        
        title = old_row[4]
        phase = old_row[15]
        trial_source_id = old_row[0]
        trial_source = old_row[38]
        if trial_source_id in intervention_dict:
            drug_name = intervention_dict[trial_source_id]
        else:
            drug_name = 'N/A'
        if trial_source_id in condition_dict:
            related_disease = condition_dict[trial_source_id]
        else:
            related_disease = 'N/A'
        if trial_source_id in condition_mesh_dict:
            disease_mesh_term = condition_mesh_dict[trial_source_id]
        else:
            disease_mesh_term = 'N/A'
        if mesh_pattern.search(disease_mesh_term) or mesh_pattern.search(related_disease):
            cancer_related = 'Yes'
        else:
            cancer_related = 'N/A'
        if phase == 'N/A':
            rank_row = 'Z'
        else:
            rank_row = phase[-7:]
        new_row = [drug_name, related_disease, disease_mesh_term, cancer_related, title, phase, trial_source_id, trial_source, rank_row]
        csvwriter.writerow(new_row)

output_file.close()

