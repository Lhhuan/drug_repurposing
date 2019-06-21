#筛选出不在../output/01_filter_missense_protein.txt 的"/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz"，得../output/02_filter_no_in_uniparc.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/hongcheng/uniprot_db/uniparc.gz";
my $f2 ="../output/01_filter_missense_protein.txt";
my $fo1 ="../output/02_filter_in_uniparc.txt"; 
my $fo2 ="../output/02_filter_no_in_uniparc.txt"; 
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
print $O2 "SWISSPROT\tTREMBL\tUNIPARC\n";

my(%hash1,%hash2,%hash3);

while(<$I1>)
{
    chomp;
    if (/^\>/){
        my @f =split/\s+/;
        my $protein = $f[0];
        $protein =~s/>UNIPARC://g;
        $hash1{$protein}=1;
    }
    
}

while(<$I2>)
{
    chomp;
    unless (/^variant_id/){
        my @f =split/\s+/;
        my $variant_id = $f[0];
        my $SWISSPROT = $f[1];
        my $TREMBL =$f[2];
        my $UNIPARC = $f[3];
        my $protein = join("\t",@f[1..3]);
        if (exists $hash1{$SWISSPROT}){
            unless(exists $hash2{$SWISSPROT}){
                $hash2{$SWISSPROT} =1;
                print $O1 "$SWISSPROT\n";
            }
        }
        elsif(exists $hash1{$TREMBL}){
            unless(exists $hash2{$TREMBL}){
                $hash2{$TREMBL} =1;
                print $O1 "$TREMBL\n";
            }
        }
        elsif(exists $hash1{$UNIPARC}){
            unless(exists $hash2{$UNIPARC}){
                $hash2{$UNIPARC} =1;
                print $O1 "$UNIPARC\n";
            }
        }
        else{
            unless (exists $hash3{$protein}){
                $hash3{$protein}=1;
                print $O2 "$protein\n";
            }
        }
    }
    
}

