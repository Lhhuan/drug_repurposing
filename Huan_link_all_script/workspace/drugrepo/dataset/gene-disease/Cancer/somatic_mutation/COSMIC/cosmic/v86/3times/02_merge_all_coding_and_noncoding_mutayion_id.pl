#将coding 文件中，出现三次以上的variant筛选出来。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

my $fo1 = "./All_cosmic_Muts_mutation_id_largethan2_nm.vcf";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";



open my $DATE1, 'zcat ../../CosmicCodingMuts.vcf.gz|' or die "zcat CosmicCodingMuts.vcf.gz $0: $!\n"; 
my %hash1;
my %hash2;
while(<$DATE1>)
{
    unless (/^#/){
     chomp();  
      my @f1 = split /\s+/;
      unless ($f1[4] =~ /\./){  #alt 为.的去掉。
          my $chrom = $f1[0];
          my $pos = $f1[1];
          my $ref = $f1[3];
          my $alt = $f1[4];
          my $ref_len = length ($ref);
          my $alt_len = length ($alt);
          if ($ref_len ==1 ){
              if ($ref =~ /A|T|C|G/){
                  if ($alt_len == 1){ #只要长度为1的
                      if ($alt =~/A|T|C|G/){ #只要碱基为atcg的，有的allele写的是m
                          my $key =$chrom."\t".$pos."\t".$ref."\t".$alt;
                          push @{$hash1{$key}},$_;
                     }
                }
             }          
         }
    }
  }
}

foreach my $key (sort keys %hash1){
    my @v = @{$hash1{$key}};
    my $num = @v;
    if($num > 2){
        foreach my $v(@v){
            print $O1 "$v\n";
        }
    }
}
#-----------------------------------------------
open my $DATE, 'zcat ../../CosmicNonCodingVariants.vcf.gz|' or die "zcat CosmicNonCodingVariants.vcf.gz $0: $!\n";  
my %hash3;
my %hash4;
while(<$DATE>)
{
    unless (/^#/){
     chomp();  
      my @f1 = split /\s+/;
      unless ($f1[4] =~ /\./){  #alt 为.的去掉。
          my $chrom = $f1[0];
          my $pos = $f1[1];
          my $ref = $f1[3];
          my $alt = $f1[4];
          my $ref_len = length ($ref);
          my $alt_len = length ($alt);
          if ($ref_len ==1 ){
              if ($ref =~ /A|T|C|G/){
                  if ($alt_len == 1){ #只要长度为1的
                      if ($alt =~/A|T|C|G/){ #只要碱基为atcg的，有的allele写的是m
                          my $key =$chrom."\t".$pos."\t".$ref."\t".$alt;
                          push @{$hash3{$key}},$_;
                     }
                }
             }          
         }
    }
  }
}

foreach my $key (sort keys %hash3){
    my @v = @{$hash3{$key}};
    my $num = @v;
    if($num > 2){
       foreach my $v(@v){
            print $O1 "$v\n";
        }
        
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
