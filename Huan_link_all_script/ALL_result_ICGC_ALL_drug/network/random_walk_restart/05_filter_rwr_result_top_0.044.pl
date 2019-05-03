 #把./output/huan_data_rwr/rwr_result/${drug}_sorted.txt 里面的每个drug rwr result,取top4.4%， 把筛选结果放在./output/huan_data_rwr/rwr_result_top_0.044/

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/03_huan_drug_target_num.txt";#输入的是drug target
 open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
 my %hash1;

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^drug/){
        my $drugname = $f[0];
        $hash1{$drugname}=1;
    }
}

# my $fo2 ="./drug_list.txt"; 
# open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

foreach my $drug (sort keys %hash1){
    my $line = 0.044*12277;
    my $line2  = sprintf "%.f", $line; # 这个是四舍五入取整

    #print $O1 "$drug\n";
    system "head -n $line2 ./output/huan_data_rwr/rwr_result/${drug}_sorted.txt > ./output/huan_data_rwr/rwr_result_top_0.044/${drug}.txt";

}