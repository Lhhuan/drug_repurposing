#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $fi_step1result ="./getfromdrugbank2017-12-18.txt";
#my $fi_step1result ="./test.txt";
my $fi_p_e ="./wgEncodeGencodeUniProtV24lift37.txt";
my $fi_e_e ="./ensGene.txt";
my $fo = "./step2_result_gene_drug.txt";
#my $fo = "./step21_result_gene_drug.txt";
#跑出来结果后，用vi进入，然后把DB09037的亮星点和在Indiacation 里面出现的多余的制表符删掉。


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
            my $uniprot_ID = $f1[3];
            my $t = join "\t", @f1[0..2,4..14];
            push @{$hash1{$uniprot_ID}},$t;
        }
    }

}




while(<$fh_p_e>)
{
    chomp;
  if (s/\.\d+//){
        my @f2 = split /\t/;
        my $UniprotID2 = $f2[1];
        my $ENSTID = $f2[0];
        push@{$hash2{$UniprotID2}},$ENSTID;
    }
}

while(<$fh_e_e>)
{
    chomp;
   
    if (/EN\S/){
         my @f3 = split /\t/;
          if ($f3[0] !~/^$/){
         my $ENSTID = $f3[1];
         my $ENSGID = $f3[12];
           $hash3{$ENSTID}=$ENSGID;
          }
    }
}

foreach my $uniprot_ID (sort keys %hash1){
    if(exists $hash2{$uniprot_ID}){
        my @drugs = @{$hash1{$uniprot_ID}};
        #my $ENSTID = $hash2{$uniprot_ID};
        my @ENSTIDs = @{$hash2{$uniprot_ID}};
        foreach my $ENSTID(@ENSTIDs){
            if (exists $hash3{$ENSTID}){
                my $ENSGID = $hash3{$ENSTID};
                foreach my $drug(@drugs){
                    my $key4 = "$ENSGID\t$ENSTID\t$uniprot_ID\t$drug";
                    unless(exists $hash4{$key4}){
                        print "$key4\n";
                        $hash4{$key4} = 1; 
                    }
                }
            }
        }
     }
}
    