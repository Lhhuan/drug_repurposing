
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import json
from os import path
import matplotlib.pyplot as plt

from xgboost import XGBClassifier, XGBRegressor
from sklearn import metrics
from sklearn.metrics import roc_auc_score
from sklearn.externals import joblib

import io, subprocess
from concurrent import futures


# In[2]:


def read_bed(x, **kwargs):
    return pd.read_csv(x, sep=r'\s+', header=None, index_col=False, **kwargs)


def tabix(arguments):
    cmdline = 'tabix -p bed {}'.format(arguments)
    p = subprocess.Popen(cmdline, shell=True, stdout=subprocess.PIPE)
    stdout, _ = p.communicate()
    return read_bed(io.StringIO(stdout.decode('utf-8'))).set_index(0)


# In[3]:


def extract(line):
    # line = line.split()
    chr_id = str(line[0])

    begenPos = str(line[1])
    endPos = str(line[1])

    ref = str(line[2])
    ale = str(line[3])

    cmdline = "../mulin_score/VannoDB_FA_dbNCFP_A.gz {}:{}-{}".format(chr_id, chr_id, begenPos, endPos)

    try:
        feature = tabix(cmdline)
    except:
        print(line)
        return "None"

    feature = feature.values[:, :]
    feature_ale = feature[:, 3]
    rows = feature.shape[0]
    cols = feature.shape[1]

    for ith_row in range(0, rows):
        if feature_ale[ith_row] == ale:
            out_str = str(chr_id) + "\t" + str(endPos) + "\t" + str(ref) + "\t" + str(ale) + "\t"
            for ith_dim in range(4, cols):
                out_str = out_str + str(feature[ith_row, ith_dim]) + "\t"
            return out_str
            # out_file.write(out_str + label + "\n")
        else:
            continue

    return "None"


# # extrack features

# In[6]:


query_file = "./query_bed/08_split_tab_no_coding_path.txt"

out_file = open("./query_bed/query_dbNCFP_dataset_XY.csv", 'w')

db = pd.read_table(query_file, sep="\t", header=0)
db_values = db.values
with futures.ProcessPoolExecutor(max_workers=28) as executor:
    for future in executor.map(extract, db_values):
        if future == 'None':
            continue
        out_file.write(future+"\n")
    out_file.close()

