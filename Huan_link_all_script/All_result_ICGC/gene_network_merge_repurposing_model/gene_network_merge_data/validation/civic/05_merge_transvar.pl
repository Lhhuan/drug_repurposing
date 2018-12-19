#将./output/04_used_to_transvar.txt和./output/04_transvar_unknown_ref_alt.txt merge在一起 合成一个文件，得./output/05_merge_transvar_result.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/04_used_to_transvar.txt";
my $f2 ="./output/04_transvar_unknown_ref_alt.txt";
my $fo1 ="./output/05_merge_transvar_result.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "HGVSg\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene:variant\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt\tentrez_id\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_main_tissue_ID/){
        my $gene_variant = $f[4];
        push @{$hash1{$gene_variant}},$_;
    }
}
while(<$I2>)
{
    chomp;
    my @f= split /\s+/;
    unless (/^input/){
        my $variant = $f[0];
        my $variant_infos= $f[1];
        my @infos = split/\//,$variant_infos;
        my $g_variant = $infos[0];
        $g_variant =~s/chr//g;
        if(exists $hash1{$variant}){
            my @cancer_infos = @{$hash1{$variant}};
            foreach my $cancer_info(@cancer_infos){
                my $output = "$g_variant\t$cancer_info";
                unless(exists $hash2{$output}){
                    $hash2{$output} =1;
                    print  $O1 "$output\n";
                }
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
