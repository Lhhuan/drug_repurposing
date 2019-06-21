#将../output/07_filter_snv_in_huan.txt drug-cancer pair中的snv 数目小于X的过滤掉，得../output/071_filter_snv_in_huan.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "../output/07_filter_snv_in_huan.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 = "../output/071_filter_snv_in_huan.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    if(/^Drug_chembl_id/){
        print $O1 "$_\n";
    }
    else{
       my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
       my $oncotree_ID = $f[1];
       my $Mutation_id = $f[2];
       my $paper_sample_name = $f[-1];
       my $k  = "$Drug_chembl_id_Drug_claim_primary_name\t$oncotree_ID\t$paper_sample_name";
    #    my $k  = $paper_sample_name;
       push @{$hash1{$k}},$Mutation_id;
       push @{$hash2{$k}},$_;

    }
}


foreach my $k(sort keys %hash1){
    my @Mutation_ids = @{$hash1{$k}};
    my %hash3;
    @Mutation_ids = grep{ ++$hash3{$_}<2 }@Mutation_ids;
    my $number = @Mutation_ids;
    if ($number>1){
        if (exists $hash2{$k}){
            my @vs = @{$hash2{$k}};
            foreach my $v(@vs){
                print $O1 "$v\n";
            }
        }
    }
}
