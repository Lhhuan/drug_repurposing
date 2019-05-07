#用../output/12_merge_ICGC_info_gene_role.txt
#和"/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt" 文件merge
#得./output/pathogenicity_mutation_cancer.txt，得所有致病性mutation id文件./output/pathogenicity_mutation_ID.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/workspace/drugrepo/dataset/gene-disease/Cancer/somatic_mutation/ICGC/release_27/release_27_snv_indel/data_statistics/pathogenicity_id_cadd_score.txt"; #致病性的mutation ID
my $f2 = "../output/12_merge_ICGC_info_gene_role.txt";
my $fo1 = "./output/pathogenicity_mutation_cancer.txt";
my $fo2 = "./output/pathogenicity_mutation_ID.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O1 "CADD_MEANPHRED\t";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^ID/){
        my @f =split/\t/;
        my $mutation_id = $f[0];
        my $MEANPHRED = $f[1];
        $hash1{$mutation_id}=$MEANPHRED;
    }
}




while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if (/^Mutation_ID/){
        print $O1 "$_\n";
    }
    else{
        my $Mutation_ID =$f[0];
        push @{$hash2{$Mutation_ID}},$_;
    }
}

foreach my $Mutation_ID (sort keys %hash1){
    my $MEANPHRED = $hash1{$Mutation_ID};
    if(exists $hash2{$Mutation_ID}){
            unless(exists $hash4{$Mutation_ID}){ #
                print $O2 "$Mutation_ID\n"; 
            }
        my @cancer_infos = @{$hash2{$Mutation_ID}};
        foreach my $cancer_info(@cancer_infos){
            my $output = "$MEANPHRED\t$cancer_info";
            unless(exists $hash3{$output}){
                $hash3{$output}=1;
                print $O1 "$output\n";
            }
        }

    }
    # else{
    #     print "$Mutation_ID\n";
    # }
}



