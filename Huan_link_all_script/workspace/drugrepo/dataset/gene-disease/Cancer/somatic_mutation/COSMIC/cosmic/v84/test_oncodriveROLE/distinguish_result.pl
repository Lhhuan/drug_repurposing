#用/oncodrivecluster/cancer_gene_census.txt 检查oncodriverole_perdiction_result.txt 的真假
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./cancer_gene_census.txt";
my $f2 ="./perdiction_result.txt";
my $fo1 = "./distinguish_in_CGC.txt";
my $fo2 = "./distinguish_out_CGC.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "Gene_symbol\trole_in_CGC\tGene_symbol\tprob_Act\tprob_LoF\tOncodriveROLE\n";
select $O1;
print $title;
select $O2;
print "Gene_symbol\tprob_Act\tprob_LoF\tOncodriveROLE\n";
my(%hash1,%hash2,%hash3);
       

while(<$I1>)  #CNA
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene/){
        my $gene_symbol = $f[0];
        my $rule_in_cancer = $f[14];
        $hash1{$gene_symbol}=$rule_in_cancer;
        if($f[1]=~/^\s+/){
            #my $rule_in_cancer = $f[14];
            my $rule_in_cancer = "NA";
            $hash1{$gene_symbol}=$rule_in_cancer;
            }
        else{
            my $rule_in_cancer = $f[14];
            $hash1{$gene_symbol}=$rule_in_cancer;
        }   
     }
}                    

while(<$I2>) #03_MUTS_trunc_mutfreq.txt
{
    chomp;
    my @f= split /\s+/;
     unless(/^Gene_symbol/){
         my $Gene_symbol = $f[0];
         my $prob_Act = $f[1];
         my $prob_LoF = $f[2];
         my $OncodriveROLE = $f[3];
         $hash2{$Gene_symbol}=$_;                 
     }
}                    


foreach my $ID (sort keys %hash2){
    if (exists $hash1{$ID}){
        my $rule_in_cancer = $hash1{$ID};
        my $v2 = $hash2{$ID};
        my $output = "$ID\t$rule_in_cancer\t$v2";
        print $O1 "$output\n";
        }
    else{
        my $v2 = $hash2{$ID};
        print $O2 "$v2\n";
    }
}