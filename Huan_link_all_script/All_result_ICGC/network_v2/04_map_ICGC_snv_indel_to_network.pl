#把../11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt 和network_gene_num.txt   merge ,得到icgc文件的entrez 在network 中的重叠以及在网络中的编号。得文件04_map_ICGC_snv_indel_in_network_num.txt,得不在网络中的gene文件，
#04_map_ICGC_snv_indel_out_network.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../11_merge_ICGC_occurthan1_snv_indel_mutationID_project_oncotree.txt";
my $f2 ="./network_gene_num.txt";
my $fo1 ="./04_map_ICGC_snv_indel_in_network_num.txt"; 
my $fo2 ="./04_map_ICGC_snv_indel_out_network.txt"; #没有number，即在网络中没有这个基因，这个基因不能作为终点。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "entrezgene\tid\n"; 
select $O2;
# print "entrezgene\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f=split/\t/;
    unless(/^Mutation_ID/){
        my $entrez_id = $f[3];
        $hash1{$entrez_id} = 1;

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

foreach my $entrezgene (sort keys %hash1){
    if (exists $hash2{$entrezgene}){
        my $id = $hash2{$entrezgene};
        #print $O1 "$entrez_id\t$id\n";
        print $O1 "$entrezgene\t$id\n";

    } 
    else{
        print $O2 "$entrezgene\n";
    }

}




