
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./somatic_uni_entrez.txt";
my $f2 ="./network_gene_num.txt";
my $fo1 ="./somatic_uni_entrez_num.txt"; #有number 的start somatic gene,
#my $fo1 ="./somatic_uni_entrez_num.txt"; 
my $fo2 ="./no_somatic_uni_entrez_num.txt"; #没有number，即在网络中没有这个基因，这个基因不能作为终点。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
# print "entrezgene\tid\n"; 
select $O2;
# print "entrezgene\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f=split/\t/;
    unless(/^Drug_chembl_id/){
        my $entrez_id = $f[0];
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

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $entrez_id = $hash1{$ID};
        my $id = $hash2{$ID};
        #print $O1 "$entrez_id\t$id\n";
        print $O1 "$id\n";

    } 
    else{
        print $O2 "$ID\n";
    }

}




