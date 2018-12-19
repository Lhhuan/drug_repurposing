#从./output/ICGC_mutation_id_HVSGg.txt中筛选./output/05_merge_transvar_result.txt中的mutation，得./output/07_filter_mutation_in_ICGC.txt,
#并提取unique的mutation cancer drug pair 得文件./output/07_unique_mutation_drug_cancer_pair.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/ICGC_mutation_id_HVSGg.txt";
my $f2 ="./output/05_merge_transvar_result.txt";
my $fo1 ="./output/07_filter_mutation_in_ICGC.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print  $O1 "Mutation_ID\tHGVSg\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene:variant\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt\tentrez_id\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^Mutation_ID/){
        my $Mutation_ID =$f[0];
        my $HGVSg = $f[1];
        push@{$hash1{$HGVSg}},$Mutation_ID;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^HGVSg/){
        my $HGVSg = $f[0];
        if (exists $hash1{$HGVSg}){
            my @Mutation_IDs = @{$hash1{$HGVSg}};
            foreach my $Mutation_ID(@Mutation_IDs){
                my $output = "$Mutation_ID\t$_";
                unless(exists $hash1{$output}){
                    $hash1{$output}=1;
                    print $O1 "$output\n";
                }
            }

        }
    }
}



close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

system "cat ./output/07_filter_mutation_in_ICGC.txt | cut -f1,2,3,4 | sort -u >./output/07_unique_mutation_drug_cancer_pair.txt";