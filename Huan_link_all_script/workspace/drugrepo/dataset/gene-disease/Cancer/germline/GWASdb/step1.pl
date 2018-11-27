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
             if ($f1[14] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma|Glioblastoma/i){
               print $_."\n"
             }
            elsif($f1[16] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma|Glioblastoma/i){
                print $_."\n"
            }
            elsif($f1[18] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma|Glioblastoma/i){
                     print $_."\n"
           }
           elsif($f1[20] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma|Glioblastoma/i){
                     print $_."\n"
          }
          elsif($f1[22] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma|Glioblastoma/i){
                      print $_."\n"
         }
         elsif($f1[23] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma|Glioblastoma/i){
                     print $_."\n"
         }    
          }
        }
      }
}