#借助"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/out_ICGC/output/03_merge_cgi_and_other_mutation_out_icgc_unique_muatation_vep.vcf"
#call出12_add_project_mutation_id.txt 中mutation的位置，得13_add_snv_position.txt, 13_add_indel_positive.txt, 13_add_project_mutation_id_position.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/match_actionable_drive_mutation/release_27/add_actionable_driver_to_pathogenicity/out_ICGC/output/03_merge_cgi_and_other_mutation_out_icgc_unique_muatation_vep.vcf";
my $f2 = "12_add_project_mutation_id.txt";
my $fo1 = "./13_add_snv_position.txt";
my $fo2 = "./13_add_indel_position.txt";
my $fo3 = "./13_add_project_mutation_id_position.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
my $output = "Mutation_ID\tchr\tpos\tref\talt";
print $O1 "$output\n";
print $O2 "$output\n";
print $O3 "Mutation_ID\tproject\tchr\tpos\tref\talt\n";
while(<$I1>)
{
    chomp;
    unless (/^#/){
        my @f = split/\t/;
        my $hgvsg =$f[2];
        my $Mutation_ID =  "Add"."$hgvsg";
        my $CHROM =$f[0];
        my $POS =$f[1];
        my $REF = $f[3];
        my $ALT = $f[4];
        my $v= "$CHROM\t$POS\t$REF\t$ALT";
        $hash1{$Mutation_ID}=$v;
    }
}


while(<$I2>)
{
    chomp;
    unless (/^ID/){
        my @f =split/\t/;
        my $id =$f[0];
        my $project =$f[1];
        if (exists $hash1{$id}){
            my $pos_info = $hash1{$id};
            my $output= "$id\t$pos_info";
            unless(exists $hash2{$output}){
                $hash2{$output} =1;
                if ($id =~/ins|del/){
                    print $O2 "$output\n"; #indel
                    print $O3 "$_\t$pos_info\n";
                }
                else{ #snv
                     print $O1 "$output\n"; #snv
                     print $O3 "$_\t$pos_info\n";
                }
            }
        }
        else{
            print "$id\n";
        }
    }
}






# while(<$I2>)
# {
#     chomp;
#     unless (/^ID/){
#         my @f =split/\t/;
#         my $id =$f[0];
#         my $project =$f[1];
#         if ($id =~/del|ins/){
#             if (exists $hash1{$id}){
#                 my $pos_info = $hash1{$id};
#                 my $output= "$id\t$pos_info";
#                 unless(exists $hash2{$output}){
#                     $hash2{$output} =1;
#                     print $O1 "$output\n";
#                 }
#             }
#             else{
#                 print "$id\n";
#             }
#         }
#         else{
#             my $Mutation_ID = $id;
#             $Mutation_ID =~ s/Add//g;
#             $Mutation_ID =~ s/g.//g;
#             my @t =split /\:/,$Mutation_ID;
#             my $chr = $t[0];
#             $t[1] =~ /(\d+)/g;
#             my $pos = $1;
#             my $allele = $t[1];
#             $allele =~s/\d+//g;
#             if ($Mutation_ID =~/\>/){
#                 my @e = split/\>/,$allele;
#                 my $ref = $e[0];
#                 my $alt = $e[1];
#                 my $output ="$id\t$chr\t$pos\t$ref\t$alt";
#                 unless(exists $hash2{$output}){
#                     $hash2{$output} =1;
#                     print $O1 "$output\n";
#                 }
#             }
#             # else{
#             #     print "$Mutation_ID\n";
#             # }
#         }
#     }
# }
