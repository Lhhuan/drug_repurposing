#把02_mutation_out_protein_coding_map_gene.vcf转成bed文件，得03_normal_merge_all_data.bed 就是给源文件添加bed 文件需要的前三列,
use warnings;
use strict; 
use utf8;


my $f1 = "./02_mutation_out_protein_coding_map_gene.vcf";
my $fo1 = "./03_normal_merge_all_data.bed";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# my $title = "region\tgene\tscore\tsource";
# print $O1 "$title\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f =split/\s+/;
    unless(/^#/){
        my $k =join ("\t",@f[0..13]);
        my $region = $f[1];
        my @f1 = split/\:/,$region;
        my $chr =$f1[0];
        my $region1= $f1[1];
        my @f2 = split/\-/,$region1;
        my $num = @f2;
        if ($num==1){
            my $start =$f2[0]-1;
            my $end = $f2[0];
            print $O1 "$chr\t$start\t$end\t$k\n";
        }
        else{
            my $start =$f2[0]-1;
            my $end = $f2[1];
            print $O1 "$chr\t$start\t$end\t$k\n";
        }
    }
    
}


close $I1 or warn "$0 : failed to close output file '$f1' : $!\n";

