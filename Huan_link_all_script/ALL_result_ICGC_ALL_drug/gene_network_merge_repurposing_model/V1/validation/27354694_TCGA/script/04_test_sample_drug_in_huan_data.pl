#检测../data/table_s2.txt中的drug 和"/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt"中drug的overlap,
#得overlap的drug文件./output/04_overlap_drug.txt,及其sample信息得../output/04_overlap_drug_sample_infos.txt，得没有overlap 的drug文件../output/04_no_overlap_drug.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/all_drug_infos_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../data/table_s2.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "../output/04_overlap_drug.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "../output/04_overlap_drug_sample_infos.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $fo3 = "../output/04_no_overlap_drug.txt";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);
print $O1 "Drug_chembl_id|Drug_claim_primary_name\tDrug\n";
print $O2 "Drug_chembl_id|Drug_claim_primary_name\tDrug\tbcr_patient_barcode\tmeasure_of_response\n";



while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id = $f[0];
        my $Drug_claim_primary_name =$f[4];
        # print STDERR "$Drug_claim_primary_name\n";
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);#为了避免同一种Drug_chembl_id_Drug_claim_primary_name 有两个名字A-B和AB而造成的重复，此处对Drug_chembl_id_Drug_claim_primary_name进行处理。
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/,//g;
        $Drug_claim_primary_name =~s/'//g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\;//g;
        $Drug_claim_primary_name =~s/\://g;
        push @{$hash1{$Drug_claim_primary_name}},$Drug_chembl_id;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Cancer/){
        my $bcr_patient_barcode = $f[1];
        my $drug = $f[2];
        my $measure_of_response = $f[4];
        my $out  = "$bcr_patient_barcode\t$measure_of_response";
        my $Drug =$drug;
        $Drug = uc($Drug);#为了避免同一种Drug_chembl_id_Drug_claim_primary_name 有两个名字A-B和AB而造成的重复，此处对Drug_chembl_id_Drug_claim_primary_name进行处理。
        $Drug =~s/{//g;
        $Drug =~s/}//g;
        $Drug =~s/"//g;
        $Drug =~s/\(//g;
        $Drug =~s/\)//g;
        $Drug =~s/\s+//g;
        $Drug =~s/-//g;
        $Drug =~s/_//g;
        $Drug =~s/\]//g;
        $Drug =~s/\[//g;
        $Drug =~s/\//_/g;
        $Drug =~s/\&/+/g; #把&替换+
        $Drug =~s/,//g;
        $Drug =~s/'//g;
        $Drug =~s/\.//g;
        $Drug =~s/\+//g;
        $Drug =~s/\;//g;
        $Drug =~s/\://g;
        if (exists $hash1{$Drug}){
            my @chembls = @{$hash1{$Drug}};
            foreach my $chembl(@chembls){
                my $output1 = "$chembl\t$Drug";
                my $output2 = "$chembl\t$Drug\t$out";
                unless(exists $hash2{$output1}){
                    $hash2{$output1} =1;
                    print $O1 "$output1\n"; 
                }
                unless(exists $hash4{$output2}){
                    $hash4{$output2} =1;
                    print $O2 "$output2\n"; 
                }

            }
        }
        else{
            unless(exists $hash3{$drug}){
                $hash3{$drug}=1;
                print $O3 "$drug\n"; 
            }
        }
    }
}