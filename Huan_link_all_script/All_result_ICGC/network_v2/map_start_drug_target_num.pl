#将unique_drug_target_symbol_ensg_id.txt的gene_symbol和ensg换成id，得在本底网络中有的基因文件start_drug_target_network_num.txt，，得在本底网络中没有的基因文件no_start_drug_target_network_num.txt，共487个基因。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./unique_drug_target_symbol_Entrez_id.txt";
my $f2 ="./network_gene_num.txt";
my $fo1 ="./start_drug_target_network_num.txt"; #有number 的start drug target, 
my $fo2 ="./no_start_drug_target_network_num.txt"; #没有number，即在网络中没有这个基因，这个基因不能作为起点。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "gene_symbol\tentrez\tid\n"; 
select $O2;
print "gene_symbol\tentrez\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f=split/\t/;
    unless(/^Drug_chembl_id/){
        my $gene_symbol= $f[0];
        my $entrez_id = $f[1];
        $hash1{$entrez_id} = $gene_symbol;

    }
    
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^gene_symbol/){
         my $entrezgene = $f[1];
         my $id = $f[2];
         $hash2{$entrezgene} = $id;
     }
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $gene_symbol = $hash1{$ID};
        my $id = $hash2{$ID};
        #print $O1 "$ID\t$s\n";
        print $O1 "$gene_symbol\t$ID\t$id\n";
    } 
    else{
        my $gene_symbol = $hash1{$ID};
        print $O2 "$gene_symbol\t$ID\n";
    }

}




