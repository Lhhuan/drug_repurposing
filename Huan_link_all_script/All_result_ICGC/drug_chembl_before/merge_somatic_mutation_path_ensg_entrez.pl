## 把somatic_uni_ENSG_ID.txt和somatic_mutation_path.txt merge成一个文件，得somatic_mutation_path_ensg_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./somatic_mutation_path.txt";
my $f2 ="./somatic_ensg_entrez.txt";
my $fo1 ="./somatic_mutation_path_ensg_entrez.txt"; #在three_source_gene_role_final.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
print "Chrom:pos.alt.ref\tMutation_id\tENSG_ID\tSymbol\tEntrez_ID\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Chrom/){
         my $Chrom = $f[0];
         my $Mutation_id =$f[1];
         my $ENSG_ID = $f[2];
         my $Symbol = $f[3];
         my $k = join ("\t",@f[0..3]);
         push @{$hash1{$ENSG_ID}},$k;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $ensg_id = $f[0];
         my $entrezgene = $f[3];
        #  print "$ensg\n";
         $hash2{$ensg_id} = $entrezgene;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $entrezgene = $hash2{$ID};
        my @symbols = @{$hash1{$ID}};
        foreach my $symbol(@symbols){
            print $O1 "$symbol\t$entrezgene\n";
        }
        
    } 
    else {
        my @symbols = @{$hash1{$ID}};
        foreach my $symbol(@symbols){
            print $O1 "$symbol\tNA\n";
        }
    }
}

