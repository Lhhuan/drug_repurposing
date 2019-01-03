#把19_ICGC_Indel_SNV_repo-may_success_logic_ture.txt的drug，gene,repo,indication输出，得19_logic_ture_drug_gene_repo_indication.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./19_ICGC_Indel_SNV_repo-may_success_logic_true.txt";
my $fo1 ="./19_logic_ture_drug_gene_repo_indication1.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "orginal_disease\tdrug\tsymbol\trepo_cancer\n";


my(%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Mutation_ID/){
         my $project_full_name = $f[6];
         my $oncotree_id = $f[11];
         my $symbol = $f[15];
         my $drug_name = $f[20];
         my $indication = $f[30];
         my $indication_oncotree_id = $f[-1];
        # my $cancer = "$project_full_name($oncotree_id)";
        my $cancer = $oncotree_id;
         my $disease = "$indication($indication_oncotree_id)";
         push @{$hash1{$drug_name}},$cancer;
         push @{$hash2{$drug_name}},$disease;
         push @{$hash3{$drug_name}},$symbol;
     }
}

foreach my $drug(sort keys %hash1){
    my @cancers= @{$hash1{$drug}};
    my %hash6;
    @cancers = grep { ++$hash6{$_} < 2 } @cancers;  #对数组内元素去重
    my @diseases = @{$hash2{$drug}};
    my %hash5;
     @diseases = grep { ++$hash5{$_} < 2 } @diseases; 
    my @symbols = @{$hash3{$drug}};
    my %hash7;
     @symbols = grep { ++$hash7{$_} < 2 } @symbols; 
    my $cancer = join(";",@cancers);
    my $disease = join(";",@diseases);
    my $symbol = join (";",@symbols);
    my $out = "$disease\t$drug\t$symbol\t$cancer";
    unless(exists $hash4{$out}){
        $hash4{$out} =1;
        print $O1 "$out\n";
    }
}
