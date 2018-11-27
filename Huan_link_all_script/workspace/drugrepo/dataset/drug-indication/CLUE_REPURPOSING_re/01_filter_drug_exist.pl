#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将为没有target的药物在dgidb中寻找target。

my $f1 = "./dgidb_drugbank.txt";
my $f2 = "./huan_target_drug_indication.txt";
my $f3 = "./Repurposing_Hub_export.txt";
my $fo1 = "./01_exist_huan.txt"; #在huan中存在的药物
my $fo2 = "./01_out_huan_exist_dgidb.txt"; #在huan中不存在的药物，但是在dgidb中存在的药物
my $fo3 = "./01_no_exist_dgidb.txt";#在dgidb中不存在的药物。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my $header = "drug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
select $O1;
print $header;
select $O2;
print $header;
select $O3;
print $header;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
       my $drug_name = $f[8];
       $drug_name=~s/\W//g;
       $drug_name=~ s/($drug_name)/\L$1/gi;
       my $key = $drug_name;
       $hash1{$key}=1
       
     
   }
}

while(<$I2>)
{
   chomp;
   unless(/^Drug_chembl_id|Drug_claim_primary_name/){
       my @f = split/\t/;
       my $drug_name = $f[9];
       $drug_name=~s/\W//g;
       $drug_name=~ s/($drug_name)/\L$1/gi;
       my $key = $drug_name;
       $hash2{$key}=1
   }
}

while(<$I3>)
{
   chomp;
   unless(/^Name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
       my $drug_name = $f[0];
       $drug_name=~s/\W//g;
       $drug_name=~ s/($drug_name)/\L$1/gi; 
       my $key =$drug_name ;  
       #my $v = join("\t", @f[0..4,8]);
       # my($drug_name,$moa,$target,$disease_area,$indication,$phase) = ($f[0],$f[1],$f[2],$f[3],$f[4],$f[8]);
       my $v = join("\t", @f[0..4,8]);
       push @{$hash3{$key}},$v;
   }
}


foreach my $key3(sort keys %hash3){
       if(exists $hash2{$key3}){ #在huan中存在的药物。
           my @v3 = @{$hash3{$key3}};
           foreach my $v(@v3){
                   unless(exists $hash4{$v}){
                       print $O1 "$v\n";
                       $hash4{$v} = 1;
                    } 
               }
        }
        elsif(exists $hash1{$key3}){#在huan中不存在，在dgidb中存在的药物
            my @v3 = @{$hash3{$key3}};
            foreach my $v(@v3){
                   unless(exists $hash5{$v}){
                       print $O2 "$v\n";
                       $hash5{$v} = 1;
                    } 
            }    
        }     
       else{  #在dgidb中找不到target
           my @v3 = @{$hash3{$key3}};
            foreach my $v(@v3){
                   unless(exists $hash6{$v}){
                       print $O3 "$v\n";
                       $hash6{$v} = 1;
                    } 
            }    
        }
}

