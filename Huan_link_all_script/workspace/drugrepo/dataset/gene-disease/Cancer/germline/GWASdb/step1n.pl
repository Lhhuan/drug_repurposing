#!/usr/bin/perl
use warnings;
use strict;


my $fi_gwasdb ="./gwasdb_20150819_snp_trait";
open my $fh_gwasdb, '<', $fi_gwasdb or die "$0 : failed to open input file '$fi_gwasdb' : $!\n";





while(<$fh_gwasdb>)
{
    chomp;  
      my @f1 = split /\t/;
    unless (/^CHR/){
        if ($f1[7] < 1E-5){
          if ($f1[13] =~ /EUR/i){
           if ($f1[16] !~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
               if ($f1[18] !~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
                 if ($f1[20] !~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
                  # print "$_\n"
                 if ($f1[22] !~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
                   if ($f1[23] !~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
                     my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
                     print $f1[14]."\n"
    
                    }
                   }
                  }
                }
             }
           }
        }
       }
}
             

       
      

