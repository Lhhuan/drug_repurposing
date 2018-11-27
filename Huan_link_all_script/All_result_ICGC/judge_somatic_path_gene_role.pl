#判断somatic_path_gene是GOF 还是LOF，得文件judge_somatic_path_gene_role.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./somatic_mutation_path_ensg_entrez.txt";
my $f2 ="./normal_three_source_gene_role.txt";
my $fo1 ="./judge_somatic_path_gene_role.txt"; #在three_source_gene_role_final.txt中加入ensg_id 一列。 此时有29380个ensg 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
print "Chrom:pos.alt.ref\tMutation_id\tENSG_ID\tSymbol\tEntrez_ID\tRole_in_cancer\n"; 
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
         my $Entrez_ID = $f[4];
         my $k = join ("\t",@f[0..4]);
         push @{$hash1{$ENSG_ID}},$k;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^symbol/){
         my $symbol = $f[0];
         my $Prob_Act =$f[1];
         my $Prob_LoF = $f[2];
         my $Role_in_cancer = $f[3];
         my $Source = $f[4];
         my $ENSG_ID = $f[5];
        #  my $k = join ("\t",@f[1..4]);
         $hash2{$ENSG_ID} = $Role_in_cancer;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $Role_in_cancer = $hash2{$ID};
        my @genes = @{$hash1{$ID}};
        foreach my $gene(@genes){
            print $O1 "$gene\t$Role_in_cancer\n";
        }
    } 
    else {
       my @genes = @{$hash1{$ID}};
        foreach my $gene(@genes){
            print $O1 "$gene\tNA\n";
        }
    }
}

