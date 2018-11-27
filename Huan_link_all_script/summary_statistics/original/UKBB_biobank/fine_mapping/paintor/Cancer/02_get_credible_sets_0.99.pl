#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;
use Env qw(PATH);
#use Parallel::ForkManager; #多线程并行

my $f1 ="/f/mulinlab/huan/summary_statistics/original/summary_cancer_revise.txt";
#my $f1 ="./1234.txt";
#my $f1 ="./frist_miss_paintor.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
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
        if($Folder_name_local=~/UKBB_biobank/){
        # if($PMID=~/20107_13/){
            chdir "$PMID/fine_mapping_output_result";
            # chdir "$PMID/test";
            
            
            # mkdir "credible_sets_0.95";
            # chdir "./fine_mapping_output_result";
            # mkdir "12345";
            # my $paintor_result_path = "./$PMID/fine_mapping_output_result";
            my @files = glob "*.processed.results";
            chdir "../";
            system "rm -r sorted_result";
            mkdir "sorted_result";
            my $fo1 ="./all_credible_sets_0.99.txt";
            open my $O1, '>', $fo1 or die "$0 : failed to open input file '$fo1' : $!\n";
            my $header = "chromosome\tposition\trsid\treference_allele\tallele_frequency_reference_allele\talternative_allele\tallele_frequency_alternative_allele\tminor_allele\tmaf\tbaseline_allele\teffect_allele\teffect_size\(beta\)";
            $header = "$header\tstandard_error\(SE\)\todds_ratio\(OR\)\tOR_95I\tZscore\tTstat\tChisq\tOR_P\tBeta_P\tT_P\tsample_size\tAC\tytx\tPosterior_Prob";
            print $O1 "$header\n";

            foreach my $file (@files){
           
            # system "cat ./test/$file | sort -k25,25rg > ./test/sorted_${file}";
            # my $f2 ="./test/sorted_${file}"; #打开排序文件
            system "cat ./fine_mapping_output_result/$file | sort -k25,25rg > ./sorted_result/${file}_sorted";
            my $f2 ="./sorted_result/${file}_sorted"; #打开排序文件
            open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
            my $a = 0;
                while(<$I2>){
                    chomp;
                    unless(/^chromosome/){
                    my @sf = split/\s+/;
                    my $Posterior_Prob = $sf[24];
                    my $k= join"\t",(@sf[0..24]);
                    $a = $a + $Posterior_Prob;
                        if ($a <=0.99){
                            # print $O1 "$k\t$a\n";
                            print $O1 "$k\n";
                        }
                        else{
                            print $O1 "$k\t$a\n";
                            last; #跳出循环
                        }
                    }
                    
                }
            }
            close $O1 or warn "$01 : failed to close output file '$fo1' : $!\n";
            chdir "../";
        }
    }
}
      