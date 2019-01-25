#用./output/07_ICGC_mutation_id_HGVSg.txt为 ./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt 添加 HGVSg，
#得./output/08_merge_top_number_drug_sample_mutation_hgvsg.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/07_ICGC_mutation_id_HGVSg.txt";
my $f2 ="./output/06_merge_info_used_to_prediction_and_05_count_drug_number_sample.txt";
my $fo1 ="./output/08_merge_top_number_drug_sample_mutation_hgvsg.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Mutation_ID/){
        my $Mutation_ID =$f[0];
        my $HGVSg = $f[1];
        $hash1{$Mutation_ID}=$HGVSg;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id_Drug_claim_primary_name/){
        print $O1 "$_\tHGVSg\n";
    }
    else{
        my $Mutation_ID = $f[-3];
        if(exists $hash1{$Mutation_ID}){
            my $HGVSg = $hash1{$Mutation_ID};
            print $O1 "$_\t$HGVSg\n";
        }
        else{
            print STDERR "$Mutation_ID\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
