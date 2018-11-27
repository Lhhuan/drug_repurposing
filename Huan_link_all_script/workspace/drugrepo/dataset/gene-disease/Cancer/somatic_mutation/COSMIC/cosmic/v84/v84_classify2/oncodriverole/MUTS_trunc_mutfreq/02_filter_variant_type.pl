#把文件01_gene_variant_type.txt中mutation和truncating_mutations 的特定类型筛选出来
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./01_gene_variant_type.txt";
my $fo1 = "./02_filter_variant_truncating_mutations.txt";
my $fo2 = "./02_filter_variant_mutation.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "ENSG_ID\tsymbol\tvariant_type\n";
select $O1;
print $title;
select $O2;
print $title;
my(%hash1,%hash2,%hash3);
                     
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $ENSG_ID = $f[0];
    my $variant_type = $f[2];
    my $symbol = $f[1];
    # my $truncating_mutations = "splice_acceptor_variant|splice_donor_variant|stop_gained|frameshift_variant|stop_lost|start_lost|inframe_insertion|transcript_ablation";
    # $truncating_mutations= "$truncating_mutations|splice_region_variant|incomplete_terminal_codon_variant|stop_retained_variant|inframe_deletion";
    #my $truncating_mutations ="splice_acceptor_variant|splice_donor_variant|stop_gained|frameshift_variant|stop_lost|start_lost";
    my $truncating_mutations ="splice_acceptor_variant|splice_donor_variant|stop_gained|frameshift_variant|stop_lost";
    #my $mutation = "$truncating_mutations|missense_variant|protein_altering_variant"; #mutation 比truncating_mutations多一个mutation
    my $mutation = "$truncating_mutations|missense_variant";

    if ($variant_type =~ $truncating_mutations){
        print $O1 "$_\n";
    }
    if ($variant_type =~ $mutation){
        print $O2 "$_\n";
    }
}                    


