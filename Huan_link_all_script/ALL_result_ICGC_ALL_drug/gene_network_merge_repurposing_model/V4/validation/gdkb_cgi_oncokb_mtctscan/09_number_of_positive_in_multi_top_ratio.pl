#取不同的./output/08_sorted_Independent_sample_repurposing.txt top ratio，看number_of_positive，得文件./output/09_number_of_positive_in_multi_top_ratio.txt


#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use File::Basename;
use File::Copy;

my $f1 ="./output/05_filter_mtctscan_use_to_validation_positive_prediction.txt";#
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./output/08_sorted_Independent_sample_repurposing.txt";#
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/09_number_of_positive_in_multi_top_ratio.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#print $O1 "top_ratio\tpositive_number\n";
print $O1 "top_ratio\tpositive_ratio\n";
print $O1 "0\t0\n";

my %hash1;
my %hash2;

my $inject_command = "wc -l $f1";
my $line = readpipe($inject_command); #system 返回值
my @line_info = split/\s+/,$line;
my $line_number = $line_info[0];
$line_number = $line_number -1; #减去header 所占的行数
$line_number = $line_number *10;#因为随机取了10次，所以要有10倍的正样本




for (my $i=1;$i<11;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
    my $new_line_n = $line_number * $i +1;
    my $top_ratio = $i*10;
    print STDERR "$new_line_n\n";
    system "head -${new_line_n} $f2 >./output/09_predict_value_top_${top_ratio}.txt";
    my $f3 = "./output/09_predict_value_top_${top_ratio}.txt";
    open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
    my @positives;
    while(<$I3>)
    {
        chomp;
        my @f =split/\t/;
        unless(/^Drug_chembl_id_Drug_claim_primary_name/){
            my $sample_type =$f[3];
            if ($sample_type =~/1/){
                push @positives,$_;
            }
        }
    }
    my $positive_num =  @positives;
    # $new_line_n =$new_line_n-1 ;
    my $p_ratio= $positive_num / $line_number; #占正样本的比例
    $p_ratio =$p_ratio *100;
    #print $O1 "$top_ratio\t$positive_num\n";
    print $O1 "$top_ratio\t$p_ratio\n";
    close($I3);
}
