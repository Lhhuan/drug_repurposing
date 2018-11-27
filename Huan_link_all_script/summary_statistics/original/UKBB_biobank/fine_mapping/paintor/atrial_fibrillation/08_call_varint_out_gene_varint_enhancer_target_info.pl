# 把07_mutation_out_enhancer_target.txt根据mutation_id，unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt.vcf把其他的mutation的info补齐，得文件08_out_gene_varint_enhancer_target_info.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
# use Parallel::ForkManager; #多线程并行

my $f1 = "./unique_all_cancer_credible_sets_0.95_chr_pos_ref_alt.vcf";
my $f2 = "./07_mutation_out_enhancer_target.txt";
my $fo1 = "./08_out_gene_varint_enhancer_target_info.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    if (/^#/){
        print $O1 "$_\n";
    }
     else{
         my @f =split/\s+/;
        # my $Extra = $f[13];
         my $variation_id = $f[2];
         #my $location = $f[1];
         push @{$hash1{$variation_id}},$_;
     }
}


while(<$I2>)
{
    chomp;
    my @f =split/\t/;
    my $mutation_id =$f[0];
    $hash2{$mutation_id} =1;
}

foreach my $k (sort keys %hash1){
    if(exists $hash2{$k}){
        my @infos=@{$hash1{$k}};
        foreach my $info(@infos){
            unless(exists $hash4{$info}){
                $hash4{$info}=1;
                print $O1 "$info\n";
            }
        }
    }
}
