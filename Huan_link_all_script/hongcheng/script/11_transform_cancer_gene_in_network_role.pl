#用"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt" 将../output/10_normal_three_source_cancer_gene_lable.txt中的cancer gene转换为
#在网络中的编号得../output/11_normal_three_source_cancer_gene_lable_network_id.txt, 得unique的在网络中存在的cancer gene，得../output/11_unique_network_id.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/output/network_gene_num.txt";
my $f2 ="../output/10_normal_three_source_cancer_gene_lable.txt";
my $fo1 ="../output/11_normal_three_source_cancer_gene_lable_network_id.txt"; 
my $fo2 ="../output/11_unique_network_id.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O1 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tENSG\tnormal_MOA\tMOA_rule\tnetwork_id\n";
print $O2 "Entrez\tnetwork_id\n";
my(%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $entrezgene = $f[1];
         my $id = $f[2];
         $hash1{$entrezgene} = $id;
     }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene_symbol/){
        my $Gene_symbol =$f[0];
        my $Entrez =$f[1];
        if (exists $hash1{$Entrez}){
            my $id = $hash1{$Entrez};
            print $O1 "$_\t$id\n";
            my $output2 = "$Entrez\t$id";
            unless(exists $hash2{$output2}){
                $hash2{$output2} =1;
                print $O2 "$output2\n";
            }
        }
        else{
            print $O1 "$_\tNA\n";
        }
    }
}


