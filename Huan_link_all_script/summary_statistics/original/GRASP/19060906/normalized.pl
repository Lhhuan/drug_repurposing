#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./19060906_Lipid_level_measurements_HDL.txt";
my $fo1 ="./19060906_Lipid_level_measurements_HDL_normalized.txt";
my $f2 ="./19060906_Lipid_level_measurements_LDL.txt";
my $fo2 ="./19060906_Lipid_level_measurements_LDL_normalized.txt";
my $f3 ="./19060906_Lipid_level_measurements_TG.txt";
my $fo3 ="./19060906_Lipid_level_measurements_TG_normalized.txt";

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx";
select $O1;
print "$header\n";
select $O2;
print "$header\n";
select $O3;
print "$header\n";
#print  STDERR "$header\n";

while(<$I1>) 
{
    chomp;
    my @f= split /\t/;
     if(/^rs/){
         for (my $i=0;$i<17;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[0];
        #  my $chr = $f[2];
        #  my $pos = $f[3];
         #my $OR_P = $f[1]; 
         my $ref_allele = $f[1];
         $ref_allele = uc($ref_allele);
         my $alt_allele = $f[2];
         $alt_allele =uc($alt_allele);
         my $Zscore = $f[4];
         my $T_P=$f[5];
         print $O1 "NA\tNA\t$rsid\t$ref_allele\tNA\t$alt_allele\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$Zscore\tNA\tNA\tNA\tNA\t$T_P\t40463\tNA\tNA\n";
     }
}

while(<$I2>) 
{
    chomp;
    my @f= split /\t/;
     if(/^rs/){
         for (my $i=0;$i<17;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[0];
        #  my $chr = $f[2];
        #  my $pos = $f[3];
         #my $OR_P = $f[1]; 
         my $ref_allele = $f[1];
        $ref_allele = uc($ref_allele);
         my $alt_allele = $f[2];
         $alt_allele =uc($alt_allele);
         my $Zscore = $f[4];
         my $T_P=$f[5];
         print $O2 "NA\tNA\t$rsid\t$ref_allele\tNA\t$alt_allele\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$Zscore\tNA\tNA\tNA\tNA\t$T_P\t40463\tNA\tNA\n";
     }
}

while(<$I3>) 
{
    chomp;
    my @f= split /\t/;
     if(/^rs/){
         for (my $i=0;$i<17;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $rsid = $f[0];
        #  my $chr = $f[2];
        #  my $pos = $f[3];
         #my $OR_P = $f[1]; 
         my $ref_allele = $f[1];
         $ref_allele = uc($ref_allele);
         my $alt_allele = $f[2];
         $alt_allele =uc($alt_allele);
         my $Zscore = $f[4];
         my $T_P=$f[5];
         print $O3 "NA\tNA\t$rsid\t$ref_allele\tNA\t$alt_allele\tNA\tNA\tNA\tNA\tNA\tNA\tNA\tNA\t$Zscore\tNA\tNA\tNA\tNA\t$T_P\t40463\tNA\tNA\n";
     }
}

close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";



