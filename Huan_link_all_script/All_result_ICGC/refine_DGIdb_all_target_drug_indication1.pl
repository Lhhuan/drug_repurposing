#因为DGIdb_all_target_drug_indication.txt中把来源于DrugBank中的drug indication 统计了两遍，这里要对出现两次的进行去重。这步先把indication 来源于DrugBank和非 drugbank 分开。
#分别得来源是DGIdb_all_target_drug_indication_drugbank.txt和DGIdb_all_target_drug_indication_no_drugbank.txt
#并将DGIdb_all_target_drug_indication_drugbank.txt中indication_source是NA和不是NA的分开输出，得DGIdb_all_target_drug_indication_drugbank_source_NA.txt DGIdb_all_target_drug_indication_drugbank_source_not_NA.txt
#将上两个文件去重，相同的留下有link的数据，最后的文件DGIdb_all_target_drug_indication_drugbank_final.txt ，并得除link那列，drugbank的所有unique数据，用于评价DGIdb_all_target_drug_indication_drugbank_final.txt是否正确。
#DGIdb_all_target_drug_indication_drugbank_final.txt只比DGIdb_all_target_drug_indication_drugbank_unique.txt多一行header，去重正确。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./DGIdb_all_target_drug_indication.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./DGIdb_all_target_drug_indication_drugbank.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./DGIdb_all_target_drug_indication_no_drugbank.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id/){
        print $O1 "$_\n";
        print $O2 "$_\n";
    }
    else{
        my $indication_source = $f[16];
        if($indication_source =~/Drugbank/){
            print $O1 "$_\n"
        }
        else{
            print $O2 "$_\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n"; #关闭文件句柄

my $f2 ="./DGIdb_all_target_drug_indication_drugbank.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo3 ="./DGIdb_all_target_drug_indication_drugbank_source_NA.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my $fo4 ="./DGIdb_all_target_drug_indication_drugbank_source_not_NA.txt"; 
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my $fo5 ="./DGIdb_all_target_drug_indication_drugbank_final.txt"; 
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
my $fo6 ="./DGIdb_all_target_drug_indication_drugbank_unique.txt"; #除link那列，drugbank的所有unique数据，用于评价DGIdb_all_target_drug_indication_drugbank_final.txt是否正确。
open my $O6, '>', $fo6 or die "$0 : failed to open output file '$fo6' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5);
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    my $k = join("\t",@f[0..17,19]); #把除$link除外的所有列作为key ,因为这里有的drug indication 的link出现了两次。
    if(/^Drug_chembl_id/){
        print $O3 "$_\n";
        print $O4 "$_\n";
        print $O5 "$_\n";
    }
    else{
        unless(exists $hash3{$k}){
            $hash3{$k} =1;
            print $O6 "$k\n";
        }

        my $link = $f[18];
        if($link =~/NA/){  #link为NA
            print $O3 "$_\n";
            $hash1{$k}=$link;
        }
        else{
            print $O4 "$_\n";
            $hash2{$k}=$link;
        }
    }
}

foreach my $k(sort keys %hash1){   #$hash1不完全包含$hahs2, $hash2也不完全包含$hash1
    my @f= split/\t/,$k;
    my $k_out_pre= join("\t",@f[0..17]);
    my $k_out_suffix = $f[-1];
    my $link1 = $hash1{$k};
    if(exists $hash2{$k}){  #有网站
        my $link2 = $hash2{$k};
        print $O5 "$k_out_pre\t$link2\t$k_out_suffix\n";
    }
    else{ #网站为NA
        print $O5 "$k_out_pre\t$link1\t$k_out_suffix\n";
    }
}

foreach my $k (sort keys %hash2){  #不在$hash1中存在的hash2
    my @f= split/\t/,$k;
    my $k_out_pre= join("\t",@f[0..17]);
    my $k_out_suffix = $f[-1];
    my $link2 = $hash2{$k};
    unless(exists $hash1{$k}){
         print $O5 "$k_out_pre\t$link2\t$k_out_suffix\n";
    }
}