#!/usr/bin/perl
use warnings;
use strict;
use utf8;
#将为没有target的药物在dgidb中寻找target。

my $f1 = "./02_out_huan_exist_dgidb_indication_no_target.txt";
#my $f2 = "./02_no_exist_dgidb_indication_no_target.txt";
my $f3 = "./dgidb_drugbank.txt";
my $fo1 = "./03_find_drug.txt";#在dgidb中找到target
my $fo2 = "./03_no_drug.txt"; #在dgidb中找不到target
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
#open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $header = "gene\tdrug_name\tmoa\ttarget\tdisease_area\tindication\tphase\n";
select $O1;
print $header;
select $O2;
print $header;
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
   chomp;
   unless(/^drug_name/){
       my @f = split/\t/;
       my $drug_name = $f[0];
       $drug_name=~s/\W//g;
       $drug_name=~ s/($drug_name)/\L$1/gi;
       my $key = $drug_name;
       #my $v = join("\t", @f[0..4,8]);
     push @{$hash1{$key}},$_;
   }
}
# while(<$I2>)
# {
#    chomp;
#    unless(/^drug_name/){
#        my @f = split/\t/;
#        my $drug_name = $f[0];
#        $drug_name=~s/\W//g;
#        $drug_name=~ s/($drug_name)/\L$1/gi;
#        my $key = $drug_name;
#        #my $v = join("\t", @f[0..4,8]);
#       push @{$hash2{$key}},$_;
#    }
# }


while(<$I3>)
{
   chomp;
   unless(/^drug_chembl_id|drug_claim_name/){
       my @f = split/\t/;
        my $drug_claim_primary_name = $f[8];
        my $key3 = $drug_claim_primary_name;
        $key3 =~ s/\W//g;
        $key3 =~ s/($key3)/\L$1/gi;
        my $gene_name = $f[2];
        push @{$hash3{$key3}},$gene_name;
       }
}


foreach my $key1(sort keys %hash1){
       if(exists $hash3{$key1}){ #在dgidb中找不到target
           my @v1 = @{$hash1{$key1}};
           my @v3 = @{$hash3{$key1}};
           foreach my $v3(@v3){
               foreach my $v1(@v1){
                   my $v ="$v3\t$v1";
                   unless(exists $hash4{$v}){
                       print $O1 "$v\n";
                       $hash4{$v} = 1;
                    } 
               }
           }
           
       }
       else{  #在dgidb中找不到target
           my @v1 = @{$hash1{$key1}};
           foreach my $v1(@v1){
               unless(exists $hash5{$v1}){
                   print $O2 "$v1\n";
                   $hash5{$v1} = 1;
               }
           }
       }
}

# foreach my $key2(sort keys %hash2){
#        if(exists $hash3{$key2}){ #在dgidb中找不到target
#            my @v2 = @{$hash1{$key2}};
#            my @v3 = @{$hash3{$key2}};
#            foreach my $v3(@v3){
#                foreach my $v2(@v2){
#                    my $v ="$v3\t$v2";
#                    unless(exists $hash6{$v}){
#                        print $O1 "$v\n";
#                        $hash6{$v} = 1;
#                     } 
#                }
#            }
           
#        }
#        else{  #在dgidb中找不到target
#            my @v2 = @{$hash2{$key2}};
#            foreach my $v2(@v2){
#                unless(exists $hash5{$v2}){
#                    print $O2 "$v2\n";
#                    $hash7{$v2} = 1;
#                }
#            }
#        }
# }