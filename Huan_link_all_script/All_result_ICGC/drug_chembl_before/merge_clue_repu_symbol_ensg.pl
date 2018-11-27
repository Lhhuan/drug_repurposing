#将CLUE_REPURPOSING_indication_target.txt文件中加入ensg_id 一列。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./CLUE_REPURPOSING_indication_target.txt";
my $f2 ="./CLUE_REPURPOSING_symbol-ENSG_ID.txt";
my $fo1 ="./CLUE_REPURPOSING_indication_target_trans.txt"; #将CLUE_REPURPOSING_indication_target.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

# my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
# $title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
# $title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID";
my $title = "chembl_id\tdrug_name\tmoa\tgene_symbol\tdisease_area\tindication\tphase\tensg_id";
select $O1;
print "$title\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^chembl_id/){
         my $gene_symbol = $f[3];
         my $k = join ("\t", @f[0..6]);
         push @{$hash1{$gene_symbol}},$k;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Entrez_id/){
         my $Symbol = $f[0];
         my $ensg_id = $f[1];
         $hash2{$Symbol} = $ensg_id;
     }
}


foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            print $O1 "$v\t$s\n";
        }
    } 
    else {
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            my $s = "$v\tNA";
            print $O1 "$s\n";
        }
    }
}

