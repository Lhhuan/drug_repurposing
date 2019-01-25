# 将./data/from_xinyi/mtctdb_all.txt 和./data/from_xinyi/mtctscan_20190107.txt 中提出validation需要的列 到一起，得./output/mtctscan_all_need_info.txt,
#从./output/mtctscan_all_need_info.txt中筛选std_implication_result 为 Increased sensitivity *的，得./output/mtctscan_all_need_info_only_sensitivity.txt,
#并得./output/mtctscan_all_need_info_only_sensitivity.txt 中的unique cancer term，得./output/mtctscan_all_need_info_only_sensitivity_uni_cancer.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./data/from_xinyi/mtctdb_all.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./data/from_xinyi/mtctscan_20190107.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./output/mtctscan_all_need_info.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my %hash1;

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    for (my $i=0;$i<25;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NONE";
        }
        unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    unless ($f[0]=~/NONE|NULL/){
        #print STDERR "$_\n";
        my $drug_name = $f[0];
        my $gene_name = $f[1];
        my $mutation = $f[2];
        my $implication_superclass =$f[3];
        my $std_mutation = $f[21];
        my $std_mutation_super_class =$f[22];
        my $implication_type = $f[4];
        my $implication_result = $f[5];
        my $std_implication_result = $f[6];
        my $implication_confidence_level = $f[7];
        my $std_confidence_level = $f[8];
        my $related_disease = $f[9];
        my $do_id = $f[10];
        my $do_name = $f[11];
        my $chromosome = $f[13];
        my $start = $f[14];
        my $stop = $f[15];
        my $ref= $f[16];
        my $alt = $f[17];
        my $source = $f[23];
        my $version = "old";
        my $output = "$drug_name\t$chromosome\t$start\t$stop\t$ref\t$alt\t$gene_name\t$mutation\t$implication_superclass\t$std_mutation\t$std_mutation_super_class\t$implication_type";
        $output = "$output\t$implication_result\t$std_implication_result\t$implication_confidence_level\t$std_confidence_level\t$related_disease\t$do_id\t$do_name\t$source";
        $output =~s/"//g;
        if (/^drug_name/){
            print $O1 "$output\tversion\n";
        }
        else{
            print $O1 "$output\t$version\n";
        }
        
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/Drug_Name/){
        for (my $i=0;$i<25;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
            unless(defined $f[$i]){
            $f[$i] = "NONE";
            }
            unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
        }
        unless (/^NONE|NULL/){
            my $drug_name = $f[0];
            my $gene_name = $f[1];
            my $mutation = $f[2];
            my $implication_superclass =$f[3];
            my $std_mutation = $f[22];
            my $std_mutation_super_class =$f[23];
            my $implication_type = $f[4];
            my $implication_result = $f[5];
            my $std_implication_result = $f[6];
            my $implication_confidence_level = $f[8];
            my $std_confidence_level = $f[9];
            my $related_disease = $f[10];
            my $do_id = $f[11];
            my $do_name = $f[12];
            my $chromosome = $f[14];
            my $start = $f[15];
            my $stop = $f[16];
            my $ref= $f[17];
            my $alt = $f[18];
            my $source = $f[24];
            my $version = "updata";
            my $output = "$drug_name\t$chromosome\t$start\t$stop\t$ref\t$alt\t$gene_name\t$mutation\t$implication_superclass\t$std_mutation\t$std_mutation_super_class\t$implication_type";
            $output = "$output\t$implication_result\t$std_implication_result\t$implication_confidence_level\t$std_confidence_level\t$related_disease\t$do_id\t$do_name\t$source\t$version";
            print $O1 "$output\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; 
# #-------------------------------------#从./output/mtctscan_all_need_info.txt中筛选std_implication_result 为 Increased sensitivity *的，得./output/mtctscan_all_need_info_only_sensitivity.txt
my $f3 ="./output/mtctscan_all_need_info.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo2 ="./output/mtctscan_all_need_info_only_sensitivity.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 ="./output/mtctscan_all_need_info_only_sensitivity_uni_cancer.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    if (/^drug/){
        print $O2 "$_\n";
    }
    else{
        my $std_implication_result = $f[13];
        if ($std_implication_result =~/^Increased\s+sensitivity/){
            print $O2 "$_\n";
            my $cancer = $f[16];
            $cancer =lc ($cancer);
            $cancer =~ s/_/ /g;
            unless (exists $hash1{$cancer}){
                $hash1{$cancer} =1;
                print $O3 "$cancer\n"; #unique cancer term
            }
        }
        

    }
}
