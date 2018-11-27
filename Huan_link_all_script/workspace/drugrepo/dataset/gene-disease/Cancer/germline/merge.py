
# coding: utf-8

# In[1]:

import sys, os


# In[2]:

import pandas as pd


# In[3]:

meragefiledir = os.getcwd()+'/rdID-position' 


# In[6]:

file=open('result.csv','w')


# In[4]:

filenames=os.listdir(meragefiledir) 


# In[6]:

for filename in filenames:  
    filepath=meragefiledir+'/'+filename
    for line in open(filepath):  
        file.writelines(line)  
    file.write('\n')  

