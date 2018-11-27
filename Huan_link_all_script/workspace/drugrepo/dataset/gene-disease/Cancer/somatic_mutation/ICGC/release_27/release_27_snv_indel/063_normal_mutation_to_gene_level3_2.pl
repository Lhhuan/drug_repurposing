#利用04_out_gene_varint_enhancer_target_info_vep.vcf 把find_level_3.2_closest.bed normal成和上面一样的文件，得063_normalized_mutation_to_gene_level3_2.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./04_out_gene_varint_enhancer_target_info_vep.vcf";
my $f2 = "./find_level_3.2_closest.bed";
my $fo1 = "./063_normalized_mutation_to_gene_level3_2.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Uploaded_variation\tLocation\tAllele\tGene\tFeature\tFeature_type\tConsequence\tcDNA_position\tCDS_position\tProtein_position\tAmino_acids\tCodons\tExisting_variation\tExtra\tMap_to_gene_level\n";

while(<$I1>)
{
    chomp;
    unless (/^#/){
         my @f =split/\s+/;
         my $variation_id = $f[0];
         my $location = $f[1];
         my $allele = $f[2];
         my $Extra = $f[13];
        my @f1= split/;/,$Extra;
        foreach my $i(@f1){
            if($i=~/HGVSg/){
                my $out ="$location\t$allele\t$i";
                $hash1{$variation_id} =$out;
            }
        }
     }
}


while(<$I2>) 
{
    chomp;
    my @f= split/\t/;
    my $variation_id = $f[3];
    my $gene = $f[9];
    $hash2{$variation_id}=$gene;
}



foreach my $variation_id(sort keys %hash2){  #寻找离得最近的基因。
    if(exists $hash1{$variation_id}){  
      my $gene = $hash2{$variation_id};
      my $variant_info = $hash1{$variation_id};
      my @f= split/\t/,$variant_info;
      my $location = $f[0];
      my $allele = $f[1];
      my $Extra = $f[2];
      my $out= "$variation_id\t$location\t$allele\t$gene\t-\t-\t-\t-\t-\t-\t-\t-\t-\t$Extra\tlevel3.2";
      unless(exists $hash3{$out}){
          $hash3{$out}=1;
          print $O1 "$out\n";
      }
    }
}

