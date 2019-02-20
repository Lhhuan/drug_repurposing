#把../output/04_overlap_drug_sample_infos.txt和../../TCGA_28847918/output/02_all_project_cnv.txt，../../TCGA_28847918/output/02_all_project_snv.txt，分别取overlap,
#得../output/05_28847918_cnv.txt和../output/05_28847918_snv.txt  #可以看到，这得到的这两个文件都是hg19的
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 = "../output/04_overlap_drug_sample_infos.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../../TCGA_28847918/output/02_all_project_snv.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "../../TCGA_28847918/output/02_all_project_cnv.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo1 = "../output/05_28847918_snv.txt";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "../output/05_28847918_cnv.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug/){
        my $Drug_chembl_id =$f[0];
        my $Drug =$f[1];
        my $sample = $f[2];
        my $v= "$Drug_chembl_id\t$Drug";
        push @{$hash1{$sample}},$v;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if(/^sample/){
        print $O1 "Drug_chembl_id|Drug_claim_primary_name\tDrug\tpaper_sample_name\t$_\n";
    }
    else{
        my $sample_info =$f[0];
        my @samples =split /\-/,$sample_info;
        my $sample = join("-",@samples[0..2]);
        if (exists $hash1{$sample}){
            my @drug_infos = @{$hash1{$sample}};
            foreach my $drug(@drug_infos){
                my $output = "$drug\t$sample\t$_";
                unless(exists $hash2{$output}){
                    print $O1 "$output\n";
                }
            }
        }
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    if(/^sample/){
        print $O2 "paper_sample_name\t$_\n";
    }
    else{
        my $sample_info =$f[0];
        my @samples =split /\-/,$sample_info;
        my $sample = join("-",@samples[0..2]);
        if (exists $hash1{$sample}){
            print $O2 "$sample\t$_\n";
        }
    }
}