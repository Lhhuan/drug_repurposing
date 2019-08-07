#用../data/CCLE_DepMap_18q3_maf_20180718.txt 和../data/CCLE_copynumber_2013-12-03.seg.txt， ../data/CCLE_translocations_SvABA_20181221.txt  ../data/CCLE_Fusions_20181130.txt 提取../output/021_merge_sample_oncotree_chembl.txt中
#的varint 信息，得../output/snv_sample.txt  ../output/cnv_sample.txt ../output/tra_sample.txt 
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../output/021_merge_sample_oncotree_chembl.txt";
my $f2 ="../data/CCLE_DepMap_18q3_maf_20180718.txt";
my $f3 ="../data/CCLE_copynumber_2013-12-03.seg.txt";
my $f4 ="../data/CCLE_translocations_SvABA_20181221.txt";
my $f5 ="../data/CCLE_Fusions_20181130.txt";
my $fo1 ="../output/snv_sample.txt";
my $fo2 ="../output/cnv_sample.txt";
my $fo3 ="../output/tra_sample.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^CCLE_name/){
        my $ccl_name = $f[0];
       # my $k = "$CCLE_name\t$Cell_line_primary_name";
        my $k = $ccl_name;
        my $oncotree_ID_drug = join ("\t",@f[1..5],$f[-1]);
        $hash1{$k} =$oncotree_ID_drug;
        my $oncotree_id = join("\t",@f[1..4]);
        $hash2{$k} =$oncotree_id;
    }
}

print $O1 "CCLE_name\thgvsg\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tCompound\tDrug_chembl_id_Drug_claim_primary_name\n";
while(<$I2>)  #snv
{
    chomp;
    my @f= split /\t/;
    unless (/^Hugo_Symbol/){
        my $Genome_Change =$f[13];
        my $hgvsg = $Genome_Change;
        $hgvsg =~ s/g.chr//g;
        $hgvsg =~ s/\:/\:g\./g;
        my $Tumor_Sample_Barcode = $f[15];
        my @cell_name =split/\_/,$Tumor_Sample_Barcode;
        my $CCLE_name = $cell_name[0];
        if (exists $hash1{$CCLE_name}){
            my $oncotree_ID = $hash1{$CCLE_name};
            my $output = "$CCLE_name\t$hgvsg\t$oncotree_ID";
            print $O1 "$output\n";
        }
    }
}

while(<$I3>) ###cnv
{
    chomp;
    my @f= split /\t/;
    if  (/^CCLE_name/){
        print $O2 "$_\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\n"
    }
    else{
        my $out = join("\t",@f[1..5]);
        my @cell_name =split/\_/,$f[0];
        my $CCLE_name = $cell_name[0];
        if (exists $hash2{$CCLE_name}){
            my $oncotree_ID = $hash2{$CCLE_name};
            my $output = "$CCLE_name\t$out\t$oncotree_ID";
            print $O2 "$output\n";
        }
    }
}

print $O3 "CCLE_name\tchr1\tstart1\tend1\tchr2\tstart2\tend2\toncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\n";
while(<$I4>) ###tra
{
    chomp;
    my @f= split /\t/;
    unless  (/^CCLE_name/){
        my @cell_name =split/\_/,$f[0];
        my $CCLE_name = $cell_name[0];
        my $bp1 = $f[2];
        my $bp2 = $f[3];
        my @b=split/\:/,$bp1;
        my $chr1 = $b[0];
        my @p =split/\-/,$b[1];
        my $start1 = $p[0];
        my $end1 = $p[1];
        $end1 =~ s/\+//g;
        $end1 =~ s/\-//g;
        my @b2 = split/\:/,$bp2;
        my $chr2 = $b2[0];
        my @p2 = split/\-/,$b2[1];
        my $start2 = $p2[0];
        my $end2 = $p2[1];
        $end2 =~ s/\+//g;  
        $end2 =~ s/\-//g;         
        if (exists $hash2{$CCLE_name}){
            my $oncotree_ID = $hash2{$CCLE_name};
            my $output = "$CCLE_name\t$chr1\t$start1\t$end1\t$chr2\t$start2\t$end2\t$oncotree_ID";
            print $O3 "$output\n";
        }
    }
}

while(<$I5>) ###tra
{
    chomp;
    my @f= split /\t/;
    unless  (/^X.sample/){
        my @cell_name =split/\_/,$f[0];
        my $CCLE_name = $cell_name[0];
        my $bp1 = $f[6];
        $bp1 =~s/chr//g;
        my $bp2 = $f[9];
        $bp2 =~s/chr//g;
        my @b=split/\:/,$bp1;
        my $chr1 = $b[0];
        my $start1 = $b[1];
        my $end1 = $b[1];
        $end1 =~ s/\+//g;
        $end1 =~ s/\-//g;
        my @b2 = split/\:/,$bp2;
        my $chr2 = $b2[0];
        my $start2 = $b2[1];
        my $end2 = $b2[1];
        $end2 =~ s/\+//g;  
        $end2 =~ s/\-//g;             
        if (exists $hash2{$CCLE_name}){
            my $oncotree_ID = $hash2{$CCLE_name};
            my $output = "$CCLE_name\t$chr1\t$start1\t$end1\t$chr2\t$start2\t$end2\t$oncotree_ID";
            print $O3 "$output\n";
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
