#判断21_all_drug_infos.txt中在ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt 中出现的drug_cancer_pair 得16.1_drug_cancer_in_icgc_project.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./21_all_drug_infos.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 ="./ICGC_occurthan1_snv_indel_project_oncotree_normalized.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="./16.1_drug_cancer_in_icgc_project.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";



print $O1 "Drug_chembl_id|Drug_claim_primary_name\tindication_oncotree_id\n";


my(%hash1,%hash2,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug_chembl_id/){
        # my $ICGC_cancer_oncotree =$f[7];
         my $drug= $f[0];
         my $indication_oncotree = $f[-1];
         push @{$hash1{$drug}},$indication_oncotree;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^project/){
         my $oncotree_id = $f[-1];
         $oncotree_id=~s/"//g;
        $hash2{$oncotree_id}=1;
     }
}
foreach my $drug(sort keys %hash1){
    my @drug_oncos = @{$hash1{$drug}};
    my %hash3;
    @drug_oncos = grep { ++$hash3{$_} < 2 } @drug_oncos;
    foreach my $drug_onco(@drug_oncos){
        if(exists $hash2{$drug_onco}){
            my $out= "$drug\t$drug_onco";
            unless(exists $hash4{$out}){
                $hash4{$out} =1;
                print $O1 "$out\n";
            }
        }
        # else{
        #     print STDERR "$drug_onco\n";
        # }
    }
}