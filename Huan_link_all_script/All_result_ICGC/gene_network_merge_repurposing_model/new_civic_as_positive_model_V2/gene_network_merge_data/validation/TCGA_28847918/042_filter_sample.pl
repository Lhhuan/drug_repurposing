#用"./output/041_overlap_huan.txt 取./output/28847918_normal_type.txt中的信息，得./output/042_overlap_drug_sample_infos.txt
#./output/042_overlap_drug_sample_infos.txt 与./output/04_overlap_drug_sample_infos.txt 合并得最终./output/04_overlap_drug_sample_infos_final.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/28847918_normal_type.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "./output/041_overlap_huan.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/042_overlap_drug_sample_infos.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

print $O1 "Drug_chembl_id|Drug_claim_primary_name\tDrug\tSample\tValue\n";


while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $drug = $f[0];
        my $Drug =$drug;
        $Drug =~s/\(.*?$//g;
        $Drug =uc($Drug);
        $Drug =~ s/"//g;
        $Drug =~ s/'//g;
        $Drug =~ s/\s+//g;
        $Drug =~ s/,//g;
        $Drug =~s/\&/+/g;
        $Drug =~s/\)//g;
        $Drug =~s/\//_/g;
        $Drug =~s/\.//g;
        $Drug =~s/\-//g;
        push @{$hash1{$Drug}},$_;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $drug = $f[0];
        my $Drug =$drug;
        $Drug =~s/\(.*?$//g;
        $Drug =uc($Drug);
        $Drug =~ s/"//g;
        $Drug =~ s/'//g;
        $Drug =~ s/\s+//g;
        $Drug =~ s/,//g;
        $Drug =~s/\&/+/g;
        $Drug =~s/\)//g;
        $Drug =~s/\//_/g;
        $Drug =~s/\.//g;
        $Drug =~s/\-//g;
        my $chembl = $f[1];
       if (exists $hash1{$Drug}){
           my @infos = @{$hash1{$Drug}};
           foreach my $info(@infos){
               my $output = "$chembl\t$info";
               unless(exists $hash2{$output}){
                   $hash2{$output}=1;
                   print $O1 "$output\n";
               }
           }
       }
    }
}
close ($O1);

system "cat ./output/04_overlap_drug_sample_infos.txt ./output/042_overlap_drug_sample_infos.txt > ./output/04_overlap_drug_sample_infos_final.txt";