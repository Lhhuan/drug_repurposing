
# coding: utf-8

# In[ ]:

for k in $(seq 1 22)
do
     nohup python -u process_DDAF.py $k&
done

nohup python -u process_DDAF.py X

