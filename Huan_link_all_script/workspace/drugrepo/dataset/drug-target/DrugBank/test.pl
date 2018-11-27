#!/usr/bin/perl
use warnings;
use strict;
use utf8;

#my $fi_step1result ="./getfromdrugbank2017-12-18.txt";
#my $fi_step1result ="./test_cl.txt";
my $fi_step1result ="./test1.txt";
#my $fi_p_e ="./wgEncodeGencodeUniProtV24lift37.txt";
#my $fi_e_e ="./ensGene.txt";
my $fi_p_e ="./test2.txt";
my $fi_e_e ="./test3.txt";
#my $fo = "./step2_result_gene_drug.txt";
my $fo = "./step21_result_gene_drug.txt";


open my $fh_step1result, '<', $fi_step1result or die "$0 : failed to open input file '$fi_step1result' : $!\n";
open my $fh_p_e, '<', $fi_p_e or die "$0 : failed to open input file '$fi_p_e' : $!\n";
open my $fh_e_e, '<', $fi_e_e or die "$0 : failed to open input file '$fi_e_e' : $!\n";
 open my $O, '>', $fo or die "$0 : failed to open output file '$fo' : $!\n";
 select $O;
print"ENSGID\tENSTID\tUniprot_ID\tDRUG_NAME\tcas_number\ttarget_name\taction_text\tdrug_type\tbest_level\tindication\tside_effect\tcancer_prescribed\ttumor_type\tsource_id\tsource\tsource_database\tchemle_id\n";



my %hash1;
my %hash2;
my %hash3;
my %hash4;


# while(<$fh_step2result>)
# {
#     chomp;
#     unless(/^Drug_Name/){
#         my @f1 = split /\t/;
#        print $_."\n"
#     }

# }

while(<$fh_step1result>)
{
    chomp;
    unless(/^Drug_Name/){
        my @f1 = split /\t/;
        if ($f1[3] !~ /N\/A/){
             $f1[7] =~ s/\t+/\\t/g;
             $f1[8] =~ s/\t+/\\t/g;
             $f1[9] =~ s/\t+/\\t/g;
            my $uniprot_ID = $f1[3];
            my $t = join "\t", @f1[0..2,4..14];
            #print "$uniprot_ID\t$f1[1]\t$f1[-1]\n";
            #print "$f1[0]\t$f1[1]\t$f1[2]\t$f1[5]\t$f1[6]\t$f1[7]\t$f1[8]\t$f1[9]\t$f1[10]\t$f1[11]\t$f1[12]\t$f1[13]\t$f1[14]\n";
            print "$f1[0]\t$f1[1]\t$f1[2]\t$f1[5]\t$f1[6]\t$f1[7]\t$f1[8]\t$f1[9]\t$f1[10]\t$f1[11]\n";
            #print $_."\n";
            push @{$hash1{$uniprot_ID}},$t;
            #print "$uniprot_ID\t$t\n";
            #print "$t\n";
            
        }
    }

}
# foreach my $uniprot_ID(sort keys %hash1){
#                 my @k = @{$hash1{$uniprot_ID}};
#                 foreach my $t(@k){
#                     print "$uniprot_ID\t$t\n";

#                 }
#             }



# while(<$fh_p_e>)
# {
#     chomp;
#   if (s/\.\d+//){
#         my @f2 = split /\t/;
#         my $UniprotID2 = $f2[1];
#         my $ENSTID = $f2[0];
#         $hash2{$UniprotID2}=$ENSTID;
#      #   push @{$hash2 {$engeneID_T}},$UniprotID2;
#     }
# }

# while(<$fh_e_e>)
# {
#     chomp;
   
#     if (/EN\S/){
#          my @f3 = split /\t/;
#           if ($f3[0] !~/^$/){
#          my $ENSTID = $f3[1];
#          my $ENSGID = $f3[12];
#            $hash3{$ENSTID}=$ENSGID;
#           }
#     }
# }

# foreach my $uniprot_ID (sort keys %hash1){
#     if(exists $hash2{$uniprot_ID}){
#         my @drugs = @{$hash1{$uniprot_ID}};
#         my $ENSTID = $hash2{$uniprot_ID};
#         if (exists $hash3{$ENSTID}){
#             my $ENSGID = $hash3{$ENSTID};
#             foreach my $drug(@drugs){
#                 my $key4 = "$ENSGID\t$ENSTID\t$uniprot_ID\t$drug";
#                 unless(exists $hash4{$key4}){
#                     print "$key4\n";
#                     $hash4{$key4} = 1; 
#                 }
#              }
#          }
#      }
# }
    