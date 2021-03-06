
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./mulin_bio_type.txt";
# my $fo1 = "./all_level_somatic_snv_indel_gene_refine.vcf";
my $fo1 = "./mulin_unique_bio_type.txt";
my $f2 = "./unique_level1_protein_coding_consequence.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Consequence\tMap_to_gene_level\tBIOTYPE\n";


# while(<$I1>)
# {
#     chomp;
#     if (/^#/){
#         # print $O1 "$_\n";
#     }
#     else{
#         my @f = split/\t/;
#         my $mutation_ID = $f[0];
#         my $gene = $f[3];
#         my $extra= $f[13];
#         my $Map_to_gene_level =$f[14];
#         my $Consequence = $f[6];
#         if ($Map_to_gene_level =~ /Level1_protein_coding/){
#             my @bi = split/\;/,$extra;
#             foreach my $biotype (@bi){
#                 if($biotype =~/BIOTYPE/){
#                     my @bio = split /\=/,$biotype;
#                     my $type = $bio[1];
#                     my $out = "$Consequence\t$Map_to_gene_level\t$type";
#                     unless(exists $hash1{$out}){
#                         $hash1{$out} =1;
#                         print $O1 "$out\n";
#                     }
#                 }
#             }
#         }
#      }
# }

while(<$I1>)
{
    chomp;
    my @f = split/\,/;
    foreach my $bio(@f){
        $bio =~s/\s+//g;
        unless(exists $hash1{$bio}){
            $hash1{$bio} =1;
            print  $O1 "$bio\n";
        }
    }
}


while(<$I2>)
{
    chomp;
    my @f = split/\t/;
    my $con = $f[0];
    unless(exists $hash1{$con}){
        print STDERR "$con\n";
    }
    
}
