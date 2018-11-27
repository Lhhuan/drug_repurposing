
#统计药物中moa的类型及出现次数。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 = "./all_target_drug_indication.txt";
my $fo1 = "./01_statistic_drug_class.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
select $O1;
my %hash1;
while(<$I1>)
{
    unless (/^Drug_chembl_id|Drug_claim_primary_name/){
        chomp();  
        my @f1 = split /\t/;
        unless ($f1[7] =~ /na|NULL|other|unknown/){  #moa 为na|NULL|other|unknown的去掉。
          my $moa = $f1[7];
          my $Drug_claim_primary_name = $f1[9];
          my $Gene_name = $f1[3];
          my $v= "$Drug_claim_primary_name\t$Gene_name";
          push @{$hash1{$moa}},$v;
        }
    }
}


foreach my $key (sort keys %hash1){
    my @v = @{$hash1{$key}};
    my $num = @v;
    print $O1 "$key\t$num\n";       
}


close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";


# my $fo1 = "./CosmicNonCodingVariants_num.vcf";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# select $O1;

# open my $DATE, 'zcat ../../CosmicNonCodingVariants.vcf.gz|' or die "zcat CosmicNonCodingVariants.vcf.gz $0: $!\n";  
# my %hash1;
# my %hash2;
# while(<$DATE>)
# {
#     if (/^#/){
#         print $_;
#     }
#     else{
#      chomp();  
#       my @f1 = split /\s+/;
#       unless ($f1[4] =~ /\./){  #alt 为.的去掉。
#           my $chrom = $f1[0];
#           my $pos = $f1[1];
#           my $ref = $f1[3];
#           my $alt = $f1[4];
#           my $ref_len = length ($ref);
#           my $alt_len = length ($alt);
#           if ($ref_len ==1 ){
#               if ($ref =~ /A|T|C|G/){
#                   if ($alt_len == 1){ #只要长度为1的
#                       if ($alt =~/A|T|C|G/){ #只要碱基为atcg的，有的allele写的是m
#                           my $key =$chrom."\t".$pos."\t".$ref."\t".$alt;
#                           push @{$hash1{$key}},$_;
#                      }
#                 }
#              }          
#          }
#     }
#   }
# }


# foreach my $key (sort keys %hash1){
#     my @v = @{$hash1{$key}};
#     my $v = $v[0];
#     unless(exists $hash2{$v}){
#         print "$v\n";
#         $hash2{$v} = 1;
#     }
        
# }


# close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
