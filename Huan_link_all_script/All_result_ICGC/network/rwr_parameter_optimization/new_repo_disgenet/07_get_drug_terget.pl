#为06_2get_review_repodisease_gene.txt里面的drug寻找target 得有target的药物，07_review_drug_target_secondary.txt，没有target的药物文件07_review_drug_no_target_secondary.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./06_2get_review_repodisease_gene.txt"; 
my $f2 ="/f/mulinlab/huan/All_result/huan_target_drug_indication_final_symbol.txt"; 
my $fo1 ="./07_review_drug_target_secondary.txt"; #得有target的药物
my $fo2 = "./07_review_drug_no_target_secondary.txt";#没有target的药物文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "drug_name\tdrug_symbol\tdrug_entrez_ID\tsecondary\tdisease_gene\tscore\n"; 
select $O2;
# print "rxid\tname\tprimary\tsecondary\n"; 
# # print "rxid\tname\tprimary\tsecondary\tgene\tuniprot\tgene_full_name\tDPI\tDSI\tprotein_class\tscore\tEI\tnum_of_pmids\tnum_of_snps"; 
# select $O3;
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug =$f[0];
         my $secondary = $f[1];
         my $gene = $f[2];
         my $score = $f[8];
          $drug = lc($drug);
          my $v = "$secondary\t$gene\t$score";
          if($score >=0.001){
              push @{$hash1{$drug}},$v;
          }
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
         my $symbol = $f[2];
         my $Drug_claim_primary_name =$f[8];
         my $entrez = $f[4];
         $Drug_claim_primary_name = lc($Drug_claim_primary_name);
         my $v = "$symbol\t$entrez";
         push @{$hash2{$Drug_claim_primary_name}},$v;
     }
}





foreach my $drug (sort keys %hash1){
    if (exists $hash2{$drug}){
        my @diseases = @{$hash1{$drug}};
        my @genes = @{$hash2{$drug}};
        foreach my $disease(@diseases){
            my @f= split/\t/,$disease;
            my $repo_gene = $f[1];
            my $secondary = $f[0];
            my $score = $f[2];
            foreach my $gene(@genes){
                my @t= split/\t/,$gene;
                my $symbol = $t[0];
                my $entrez = $t[1];
                my $out1= "$drug\t$symbol\t$entrez\t$secondary\t$repo_gene\t$score";
                unless(exists $hash3{$out1}){
                    print $O1 "$out1\n";
                    $hash3{$out1}=1;
                }
            }
        }
    }
    else{
        my $out2 = $drug;
        unless(exists $hash4{$out2}){
            print $O2 "$out2\n";
            $hash4{$out2}=1;
        }
    }
}
