#!/usr/bin/perl
use warnings;
use strict;


my $fi_gwasdb ="./gwasdb_20150819_snp_trait";
open my $fh_gwasdb, '<', $fi_gwasdb or die "$0 : failed to open input file '$fi_gwasdb' : $!\n";



while(<$fh_gwasdb>)
{
    chomp;  
     my @f1 = split /\t/;
     my $GWAS_TRAIT =$f1[14];
               #my $HPO_TERM = $f1[16];
               # my $DO_TERM = $f1[18];
               # my $MESH_TERM = $f1[20];
               # my $EFO_TERM = $f1[22];
               # my $DOLITE_TERM = $f1[23];
               my $t = join "\t", @f1[0..29];
               
              
       unless (/^CHR/){
        if ($f1[7] < 1E-5){
          if ($f1[13] =~ /EUR/i){
             if ($f1[14] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma/i){
              #print $_."\n"
              print $f1[0]."_".$f1[1]."\n"

             }
              elsif($f1[16] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma/i){
               # print $_."\n"
                print $f1[0]."_".$f1[1]."\n"
                   }
                   elsif($f1[18] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma/i){
                   # print $_."\n"
                    print $f1[0]."_".$f1[1]."\n"
                    }
                    elsif($f1[20] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma/i){
                    # print $_."\n"
                     print $f1[0]."_".$f1[1]."\n"
                     }
                     elsif($f1[22] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma/i){
                     # print $_."\n"
                      print $f1[0]."_".$f1[1]."\n"
                    }
                    elsif($f1[23] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma/i){
                     #print $_."\n"
                     print $f1[0]."_".$f1[1]."\n"
                     }
          } 
        }
      }
}

# while(<$fh_gwasdb>)
# {
#     chomp;  
#      my @f1 = split /\t/;
#       if (/^\d+\S/){
#         if ($f1[8] < 1E-5){
#           if ($f1[14] =~ /EUR/i){
#              if ($f1[15] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#               # print $_."\n"
#              }
#               elsif($f1[17] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#                 #print $_."\n"
#                    }
#                    elsif($f1[19] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#                     # print $_."\n"
#                     }
#                     elsif($f1[21] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#                     # print $_."\n"
#                      }
#                      elsif($f1[23] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#                       #print $_."\n"
#                     }
#                     elsif($f1[24] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#                      #print $_."\n"
#                      }
#                       else {print $_."\n" }
#           }
#         }
#       }
# }

# # while(<$fh_gwasdb>)
# # {
#     chomp;  
#      my @f1 = split /\t/;
#       if (/^\d+\S/){
#         if ($f1[8] < 1E-5){
#           if ($f1[14] =~ /EUR/i){
#             # if ($f1[23] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|mesothelioma|lymphoma|Dupuytren's disease|myeloma|Neuroblastoma/i){
#                if ($f1[24 ] =~ /Neoplasms|Neoplasm|Cancers|Cancer|Neoplasia|Tumors|Tumor|Carcinoma|Melanoma|Sarcoma/i){
#               # if ($f1[14] =~ /Paget/i){
#                #my $GWAS_TRAIT =$F1[14];
#                #my $HPO_TERM = $f1[16];
#                # my $DO_TERM = $f1[18];
#                # my $MESH_TERM = $f1[20];
#                # my $EFO_TERM = $f1[22];
#                # my $DOLITE_TERM = $f1[23];
#                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
#               # print $t."\n"
#              }
#              else {
#                print $_."\n"
#              }
#           }
#         }
        
#        }
# }


# # while(<$fh_gwasdb>)
# # {
# #     chomp;  
# #      my @f1 = split /\t/;
# #       if (/^\d+\S/){
# #         if ($f1[7] < 1E-5){
# #           if ($f1[13] =~ /EUR/i){
# #              if ($f1[16] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
# #                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
# #                print $t."\n"
# #              }
# #           }
# #         }
        
# #        }
# # }

# # while(<$fh_gwasdb>)
# # {
# #     chomp;  
# #      my @f1 = split /\t/;
# #       if (/^\d+\S/){
# #         if ($f1[7] < 1E-5){
# #           if ($f1[13] =~ /EUR/i){
# #              if ($f1[18] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
# #                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
# #                print $t."\n"
# #              }
# #           }
# #         }
        
# #        }
# # }

# # while(<$fh_gwasdb>)
# # {
# #     chomp;  
# #      my @f1 = split /\t/;
# #       if (/^\d+\S/){
# #         if ($f1[7] < 1E-5){
# #           if ($f1[13] =~ /EUR/i){
# #              if ($f1[20] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
# #                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
# #                print $t."\n"
# #              }
# #           }
# #         }
        
# #        }
# # }

# # while(<$fh_gwasdb>)
# # {
# #     chomp;  
# #      my @f1 = split /\t/;
# #       if (/^\d+\S/){
# #         if ($f1[7] < 1E-5){
# #           if ($f1[13] =~ /EUR/i){
# #              if ($f1[22] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
# #                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
# #                print $t."\n"
# #              }
# #           }
# #         }
        
# #        }
# # }
# # while(<$fh_gwasdb>)
# # {
# #     chomp;  
# #      my @f1 = split /\t/;
# #       if (/^\d+\S/){
# #         if ($f1[7] < 1E-5){
# #           if ($f1[13] =~ /EUR/i){
# #              if ($f1[23] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
# #                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
# #                print $t."\n"
# #              }
# #           }
# #         }
        
# #        }
# # }



# #              if ($f1[23] =~ /Neoplasm|Cancer|Neoplasia|Tumor|Carcinoma|Melanoma|Sarcoma|Paget's disease|Malignant mesothelioma|Hodgkin's lymphoma|Dupuytren's disease|Multiple myeloma|Neuroblastoma/i){
# #                my $t = join "\t", @f1[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
              
