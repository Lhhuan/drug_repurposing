#把09_all_sorted_drug_target_repo_symbol_entrez.txt中的所有的drug_target_repo_entrez都map到"/f/mulinlab/huan/All_result/network/network_gene_num.txt"中，
#得10_all_sorted_drug_target_repo_symbol_entrez_num.txt,用于rwr训练的数据。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="./09_all_sorted_drug_target_repo_symbol_entrez.txt"; 
my $f1 ="./091_filter_all_sorted_drug_target_repo_symbol_entrez.txt"; 
my $f2 ="/f/mulinlab/huan/All_result_ICGC/network/network_gene_num.txt";
my $fo1 ="./10_all_sorted_drug_target_repo_symbol_entrez_num.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "drug_name\tdrug_symbol\tdrug_entrez\tdrug_entrez_network_id\trepo\trepo_symbol\trepo_entrez\trepo_entrez_network_id\n"; 


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name/){
         my $drug_name = $f[0];
         my $drug_symbol = $f[1];
         my $drug_entrez = $f[2];
         my $repo = $f[3];
         my $repo_symbol = $f[4];
         my $repo_entrez= $f[5];
         my $v= "$drug_name\t$drug_symbol\t$repo\t$repo_symbol\t$repo_entrez";
        push @{$hash1{$drug_entrez}},$v;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $entrez = $f[1];
         my $id = $f[2];
         $hash2{$entrez} = $id;
     }
}

#对第一列(drug_entrez)基因进行id的转换
foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID}; #在网络中的序号
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            my @f = split/\t/,$v;
            my $drug_name = $f[0];
            my $drug_symbol = $f[1];
            my $repo = $f[2];
            my $repo_symbol = $f[3];
            my $repo_entrez= $f[4];
            my $v2 = "$drug_name\t$drug_symbol\t$ID\t$s\t$repo\t$repo_symbol";
            push @{$hash3{$repo_entrez}},$v2;
            #print STDERR "$group1";
        }
    } 
}
#对repo_entrez进行转换
foreach my $ID (sort keys %hash3){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v =@{$hash3{$ID}};
        foreach my $v(@v){
            my $out = "$v\t$ID\t$s";
            print $O1 "$out\n";
        }
    }
}

            




