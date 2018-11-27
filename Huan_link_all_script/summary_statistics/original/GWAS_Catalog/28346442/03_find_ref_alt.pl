
#为没有ref alt 的文件找ref 和alt
#!/usr/bin/perl   
use warnings;
use strict;


my $f1 ="./all_credible_sets_0.99.txt";
# my $f1 ="./1234.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./all_credible_sets_0.99_no_ref_alt.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";  
my $fo2 ="./all_credible_sets_0.99_ref_alt.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";  
# my $fo3 ="./all_credible_sets_0.99.txt"; 
# open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n"; 
# my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
# $header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx\tPosterior_Prob\tsource"; 
# print $O3 "$header\n";
print $O2 "chrom\tpos\tref\talt\tFolder_name_local\n";
my %hash1;

while(<$I1>)
{
  chomp;  
  unless(/^chromosome/){
    my @f2 = split /\t/;
    my $chr = $f2[0];
    my $POS = $f2[1];
    my $pid = "$chr:$POS-$POS";
    my $r = $f2[2];
    my $Folder_name_local = $f2[-1];
    my @f = split/\:/,$r;
    my $e = @f;
    if ($e == 4){
    my $ref = $f[2];
    my $alt = $f[3];
    print $O2 "$chr\t$POS\t$ref\t$alt\t$Folder_name_local\n";
    }
    else{
        my $line = `/f/Tools/htslib/htslib-1.5/tabix  /f/mulinlab/ref_data/gnomad/gnomad.genomes.r2.0.1.sites.vcf.gz $pid`;
        if ($line=~/^$/){
          print $O1 "$chr\t$POS\n";
          }
         else{
            chomp($line);  
            my @f1 = split /\s+/,$line;
            my $chrom = $f1[0];
            my $pos = $f1[1];
            my $ref = $f1[3];
            my $alt = $f1[4];
            print $O2 "$chrom\t$pos\t$ref\t$alt\t$Folder_name_local\n";
          }
        }
                
  }
}