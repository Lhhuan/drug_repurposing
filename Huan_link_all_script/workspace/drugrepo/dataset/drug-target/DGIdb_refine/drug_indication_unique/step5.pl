#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#把搜集到的drug-indication合在一个表里。

my $f1 ="./uni-drug-2-step5_all_drug_indication1.txt"; #这两个文件中的drugbank中Drug_chembl_id|Drug_claim_name这列中Drug_claim_name是药物的名字，而现在的step1-interactions_v3_drug_target_database.txt中是source_id的匹配
my $f2 ="./uni-drug-2-step5_all_drug_indication2.txt";#这两个文件中的drugbank中Drug_chembl_id|Drug_claim_name这列中Drug_claim_name是药物的名字，而现在的step1-interactions_v3_drug_target_database.txt中是source_id的匹配
my $f3 ="./uni-drug-2-step7_drug_indication.txt";
#my $f4 ="./uni-drug-2-step9_drug_indication.txt"; #这个文件里没有indication的信息，只有一个indication的信息，所以此行不运行。
my $f5 ="./uni-drug-2-step10_drug_indication1.txt";
#my $f6 ="./uni-drug-2-step10_drug_indication2.txt";#这个文件里没有indication的信息，只有一个indication的信息，所以此行不运行。
my $f7 ="./uni-drug-2-step13-1_drug-indication-exist.txt";
my $f8 ="./uni-drug-2-step14-1_drug-indication-exist.txt";
my $f9 ="./uni-drug-2-step14-2_drug-indication-exist.txt";
my $f10 ="./uni-drug-2-step14_chembl_exist_indication.txt";
my $f11 ="./uni-drug-2-step15_drug-indication-exist.txt";
my $f12 ="./uni-drug-2-step16_drug-indication-exist.txt";
my $f13 ="./uni-drug-2-step17_drug-indication-exist.txt";
my $f14 ="./uni-drug-2-step20_drug-indication-exist.txt";
my $f15 = "./Drugbank_drug_indication.txt";                                                  #因为$f1和$f2包含的drugbank的Drug_claim_name和step1-interactions_v3_drug_target_database.txt不一致，所以这里重新加入Drug_claim_name为source_id的drugbank信息。
my $fo = "./step5_all_drug_indication.txt";


open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
#open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
#open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";
open my $I7, '<', $f7 or die "$0 : failed to open input file '$f7' : $!\n";
open my $I8, '<', $f8 or die "$0 : failed to open input file '$f8' : $!\n";
open my $I9, '<', $f9 or die "$0 : failed to open input file '$f9' : $!\n";
open my $I10, '<', $f10 or die "$0 : failed to open input file '$f10' : $!\n";
open my $I11, '<', $f11 or die "$0 : failed to open input file '$f11' : $!\n";
open my $I12, '<', $f12 or die "$0 : failed to open input file '$f12' : $!\n";
open my $I13, '<', $f13 or die "$0 : failed to open input file '$f13' : $!\n";
open my $I14, '<', $f14 or die "$0 : failed to open input file '$f14' : $!\n";
open my $I15, '<', $f15 or die "$0 : failed to open input file '$f15' : $!\n";

open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
select $O;
print "Drug_chembl_id|Drug_claim_name\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\n";  #实际上文件里都是Drug_chembl_id|Drug_claim_name没有Drug_claim_primary_name
#drug_chembl_id|drug_claim_name|drug_claim_primary_name 这里是有chembl_id的写chembl_id，如果没有chembl_id，写drug_claim_name，如果文件没有drug_claim_name就写没有就写drug_claim_primary_name。
my (%hash3,%hash4);

while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_name = $f[4];
       my $drug_indication = $f[5];
       my $drug_indication_source = $f[6];
       my $clinical_phase = "NA";
       my $link_or_refs = "NA";
       if ($drug_chembl_id =~/CHEMBL\S+/){
           my $key1 =  "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$link_or_refs";
           print "$key1\n";
       }
       else{
           my $key1 =  "$drug_claim_name\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$link_or_refs";
           print "$key1\n";
       }
   }
}

while(<$I2>)   
{
   chomp;
   unless(/^drug_claim_name/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[4];
       my $drug_claim_name = $f[0];
       my $drug_indication = $f[5];
       my $drug_indication_source = $f[6];
       my $clinical_phase = "NA";
       my $link_or_refs = "NA";
       if ($drug_chembl_id =~/CHEMBL\S+/){
           my $key1 =  "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$link_or_refs";
           print "$key1\n";
       }
       else{
           my $key1 =  "$drug_claim_name\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$link_or_refs";
           print "$key1\n";
       }
   }
}

while(<$I3>)  
{
   chomp;
   unless(/^drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0];
       my $drug_indication = $f[4];
       my $clinical_phase = $f[5];
       my $NCDid = $f[6];   #这一列可以print成refs_or_link
       my $drug_indication_source = $f[7];
       my $key1 = "$drug_claim_name\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$NCDid";
       print "$key1\n";

   }
}

while(<$I5>) 
{
   chomp;
   unless(/^drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0];
       my $drug_substance_name = $f[4];
       my $drug_indication = $f[6]; #对应文件中的disease_full_name
       my $drug_indication_source = $f[7];
       my $clinical_phase = "NA";
       my $link_or_refs = "NA";
       my $key1 = "$drug_claim_name\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$link_or_refs";
       print "$key1\n";
   }
}

while(<$I7>)   
{
   chomp;
   unless(/^drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0];
       my $drug_claim_primary_name = $f[4];
       my $drug_indication = $f[5]; 
       my $clinical_phase = $f[6];
       my $NCDid = $f[7];
       my $drug_indication_source = $f[8];
       my $key1 ="$drug_claim_name\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$NCDid";
       print "$key1\n";
      
   }
}

while(<$I8>)   
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_primary_name = $f[7];
       my $drug_indication = $f[8]; 
       my $clinical_phase = $f[9];
       my $NCDid = $f[10];
       my $drug_indication_source = $f[11];
       my $key1 ="$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$NCDid";
       print "$key1\n";
   }
}

while(<$I9>)   
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_primary_name = $f[7];
       my $MESH_ID = $f[11]; 
       my $MESH_HEADING = $f[12];
       my $EFO_ID = $f[13];
       my $EFO_NAME = $f[14];
       my $MAX_PHASE_FOR_IND = $f[15];
       my $USAN_YEAR = $f[16];
       my $REFS = $f[17];
       my $drug_indication = "$MESH_ID||$MESH_HEADING||$EFO_ID||$EFO_NAME";
       my $drug_indication_source = "NA";
       my $clinical_phase = "NA";
       my $key1 = "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$REFS";
       print "$key1\n";
       
   }
}

while(<$I10>)  
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $key1 = "$drug_chembl_id\tNA\tNA\tNA\tNA";
       print "$key1\n";
   }
}

while(<$I11>)   
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_name = $f[7];
       my $drug_indication = $f[8]; 
       my $clinical_phase = $f[9];
       my $NCDid = $f[10];
       my $drug_indication_source = $f[11];
       my $key1 = "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$NCDid";
       print "$key1\n";
   }
}

while(<$I12>)   
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_primary_name = $f[7];
       my $drug_indication = $f[8]; 
       my $clinical_phase = $f[9];
       my $NCDid = $f[10];
       my $drug_indication_source = $f[11];
       my $key1 = "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$NCDid";
       print "$key1\n";
   }
}

while(<$I13>)  
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_primary_name = $f[7];
       my $MESH_ID = $f[11]; 
       my $MESH_HEADING = $f[12];
       my $EFO_ID = $f[13];
       my $EFO_NAME = $f[14];
       my $MAX_PHASE_FOR_IND = $f[15];
       my $USAN_YEAR = $f[16];
       my $REFS = $f[17];
       my $drug_indication_source = "NA";
       my $clinical_phase = "NA";
       my $drug_indication = "$MESH_ID||$MESH_HEADING||$EFO_ID||$EFO_NAME";
       my $key1 = "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$REFS";
       print "$key1\n";
   }
}

while(<$I14>)  #"drug_chembl_id|drug_claim_name|drug_claim_primary_name\tdrug_indication\tdrug_indication_source\tclinical_phase\tlink|refs\n";
{
   chomp;
   unless(/^drug_chembl_id/){
       my @f = split/\t/;
       my $drug_chembl_id = $f[0];
       my $drug_claim_primary_name = $f[7];
       my $drug_indication = $f[9]; 
       my $clinical_phase = $f[10];
       my $link_or_refs = $f[11];
       my $drug_indication_source = "unknown";
       my $key1 = "$drug_chembl_id\t$drug_indication\t$drug_indication_source\t$clinical_phase\t$link_or_refs";
       print "$key1\n";
   }
}

while(<$I15>)
{
   chomp;
   unless(/^entrez_id/){    #"drug_chembl_id|drug_claim_name|drug_claim_primary_name\tdrug_indication\tdrug_indication_source\tclinical_phase\tlink|refs\n";
       my @f = split/\t/;
       my $drug_indication = $f[10]; 
       my $drug_claim_name= $f[14]; #原来表里的source_id
       my $drug_chembl_id = $f[17];
       my $drug_claim_primary_name = $f[4]; #原来表里的drug_name
       my $drug_indication_source = $f[16]; #原来表里的source_database;
       my $link = $f[15];  #原来表里的source;
       my $clinical_phase = "NA";
       my $k = "$drug_indication\t$drug_indication_source\t$clinical_phase\t$link";
       if ($f[10] !~ /NA/){ #不读入drugbank中没有indication的数据。
            if($f[17] !~ /NA/){  #如果chembl不是空。
                my $key3 = "$drug_chembl_id\t$k";
                unless(exists $hash3{$key3}){
                    print "$key3\n";
                    $hash3{$key3} = 1;
                }
            }
            else{
                my $key4 = "$drug_claim_name\t$k";
                unless(exists $hash4{$key4}){
                    print "$key4\n";
                    $hash4{$key4} = 1;
                }
            }
      }
   }
}




close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
#close $I4 or warn "$0 : failed to close input file '$f4' : $!\n";
close $I5 or warn "$0 : failed to close input file '$f5' : $!\n";
#close $I6 or warn "$0 : failed to close input file '$f6' : $!\n";
close $I7 or warn "$0 : failed to close input file '$f7' : $!\n";
close $I8 or warn "$0 : failed to close input file '$f8' : $!\n";
close $I9 or warn "$0 : failed to close input file '$f9' : $!\n";
close $I10 or warn "$0 : failed to close input file '$f10' : $!\n";
close $I11 or warn "$0 : failed to close input file '$f11' : $!\n";
close $I12 or warn "$0 : failed to close input file '$f12' : $!\n";
close $I13 or warn "$0 : failed to close input file '$f13' : $!\n";
close $I14 or warn "$0 : failed to close input file '$f14' : $!\n";
close $I15 or warn "$0 : failed to close input file '$f15' : $!\n";
close $O or warn "$0 : failed to close output file '$fo' : $!\n";

