#为unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep.vcf,的mutation寻找对应的gene，此step把出现在protein coding区域的mutation对应的gene找出来，得02_mutation_in_protein_coding_map_gene.vcf,没有落在protein区域的是02_mutation_out_protein_coding_map_gene.vcf
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./unique_all_cancer_credible_sets_0.99_chr_pos_ref_alt_vep.vcf";
my $fo1 = "./02_mutation_in_protein_coding_map_gene.vcf";
my $fo2 = "./02_mutation_out_protein_coding_map_gene.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    if (/^#/){
        print $O2 "$_\n";
        if (/^#Uploaded_variation/){
            print $O1 "$_\tMap_to_gene_level\n";
        }
        else{
            print $O1 "$_\n";
        }
    }
     else{
         my @f =split/\s+/;
         my $Extra = $f[13];
         my $variation_id = $f[0];
         my @f2 = split/\;/,$Extra;
         foreach my $i(@f2){
             if ($i =~/BIOTYPE/){
                 my @f3 = split/\=/,$i;
                 if ($f3[1]=~/protein_coding/){
                     push @{$hash1{$variation_id}},$_;  #只要variant 的一个注释落在protein coding，就算这个variant 所多对应的gene是该protein coding的基因，而不再进入其他variant map 到gene的规则，所以此处为去重做准备
                     print $O1 "$_\tLevel1_protein_coding\n";  
                 }
                 else{
                     push @{$hash2{$variation_id}},$_;
                    #  print $O2 "$_\n";

                 }
             }
             else{
                 push @{$hash2{$variation_id}},$_;
                 #print $O2 "$_\n";
             }
         }
     }
}

foreach my $ID(sort keys %hash2 ){
    unless(exists $hash1{$ID}){  #只要variant 的一个注释落在protein coding，就算这个variant 所多对应的gene是该protein coding的基因，而不再进入其他variant map 到gene的规则，所以此处为去重。
        my @vs =  @{$hash2{$ID}};
        foreach my $v(@vs){
            unless (exists $hash3{$v}){
                print $O2 "$v\n";
                $hash3{$v}=1;
            }
        }
    }
}

