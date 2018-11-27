#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./18535201_Warfarin_maintenance_dose.txt";
my $fo1 ="./18535201_Warfarin_maintenance_dose_normalized.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx";
select $O1;
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
         my $chr = $f[2];
         my $pos = $f[3];
         my $OR_P = $f[1]; 
         my $ref_allele = $f[7];
         my $alt_allele = $f[8];
         my $odds_ratio = $f[14];
         print $O1 "$chr\t$pos\t$rsid\t$ref_allele\tNA\t$alt_allele\tNA\tNA\tNA\tNA\tNA\tNA\t$odds_ratio\tNA\tNA\tNA\tNA\t$OR_P\tNA\tNA\t12360\tNA\tNA\n";
     }
}

close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";



