#把../output/10_prediction_logistic_regression.txt和../output/04_overlap_drug_sample_infos.txt merge 到一起，得../output/11_prediction_and_icgc_result.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
use List::Util qw/sum/;
use List::Util qw/max min/;

my $f1 = "../output/04_overlap_drug_sample_infos.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../output/10_prediction_logistic_regression.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "../output/11_prediction_and_icgc_result.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "Drug_chembl_id_Drug_claim_primary_name\tdrug_in_paper\toncotree_id\toncotree_id_type\tpaper_sample_name\tpredict_value\tvalue_in_paper\tpairs_type";
print $O1 "$header\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug =$f[1];
        my $Sample = $f[2];
        my $Value =$f[3];
        my $k = "$drug\t$Sample";
        $hash1{$k}=$Value;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id/){
        my @f =split/\t/;
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_in_paper = $f[1];
        my $oncotree_id = $f[2];
        my $oncotree_id_type = $f[3];
        my $paper_sample_name = $f[4];
        my $predict_value =$f[-1];
        my $k = "$drug_in_paper\t$paper_sample_name";
        # print STDERR "$k\n";
        if (exists $hash1{$k}){
            # print STDERR "$k\n";
            my $value_in_paper = $hash1{$k};
            my $output = "$Drug_chembl_id_Drug_claim_primary_name\t$drug_in_paper\t$oncotree_id\t$oncotree_id_type\t$paper_sample_name\t$predict_value\t$value_in_paper";
            #if ($value_in_paper =~/Complete|Partial/){ #Complete Response和Partial Response是1
            if ($value_in_paper =~/Complete/){ #Complete Response和Partial Response是1
                print $O1 "$output\t1\n";
            }
            elsif($value_in_paper =~/Stable|Progressive/){ #Stable Disease 和Clinical Progressive Disease是0
                print $O1 "$output\t0\n";
            }
            else{
                print STDERR "$output\tNA\n";
            }
        }
        else{
            print STDERR "$k\n";
        }
    }
}


close ($O1);