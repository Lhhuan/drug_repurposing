#dbNCFP_A_CAN.bed用张老师 model 跑的结果有339530行
cat dbNCFP_A_CAN.bed | perl -ane 'chomp;@f=split/\t/;if ($f[-1]>0.3857){print "$_\n";}' > ds_res.csv #有339233行