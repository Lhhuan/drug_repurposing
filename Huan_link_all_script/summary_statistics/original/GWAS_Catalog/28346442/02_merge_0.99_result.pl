
#为没有ref alt 的文件找ref 和alt
#!/usr/bin/perl   
use warnings;
use strict;


my $f1 ="/f/mulinlab/huan/summary_statistics/original/summary_cancer_revise.txt";
# my $f1 ="./1234.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo3 ="./all_credible_sets_0.99.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n"; 
my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
$header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx\tPosterior_Prob\tsource"; 
print $O3 "$header\n";
my %hash1;
# my $pm = Parallel::ForkManager->new(30); ## 设置最大的线程数目

my @text = <$I1>;#把文件读进数组
foreach my $line(@text) 
# while(<$I1>)
{
    chomp($line);
    unless($line=~/^File_name_Downloaded/){
        my @f= split /\t/,$line;
        # print "$_\n";
        my $PMID = $f[6];
        my $Folder_name_local = $f[10];   
        if($PMID=~/28346442/){
          my $file_name = "/f/mulinlab/huan/summary_statistics/original/${Folder_name_local}/fine_mapping/paintor/all_credible_sets_0.99.txt";
          open my $I2, '<', $file_name or die "$0 : failed to open input file '$file_name' : $!\n";
          
          while(<$I2>)
          {
              chomp;  
              unless(/^chromosome/){
                my @f2 = split /\t/;
                my $k = join("\t",@f2[0..24]);
                print $O3 "$k\t$Folder_name_local\n";
              }
          }
        }
    }
}


          