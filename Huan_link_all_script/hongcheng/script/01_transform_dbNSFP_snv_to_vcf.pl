#把/f/mulinlab/zhouyao/VarNoteDB/VarNoteDB_v1.0/FA/VarNoteDB_FA_dbNSFP_v3.5a/VarNoteDB_FA_dbNSFP_v3.5a.gz 转换为vep需要的vcf格式，得../output/01_dbNSFP_snv.vcf.gz
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "/f/mulinlab/zhouyao/VarNoteDB/VarNoteDB_v1.0/FA/VarNoteDB_FA_dbNSFP_v3.5a/VarNoteDB_FA_dbNSFP_v3.5a.gz";
my $fo1 = "../output/01_dbNSFP_snv.vcf.gz";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
open my $O1, "| gzip >$fo1" or die $!;

print $O1 "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^#/){
        my $Chr = $f[7];
        my $Pos = $f[8];
        my $Ref = $f[2];
        my $Alt = $f[3];
        my $output= "$Chr\t$Pos\tSNV$.\t$Ref\t$Alt\t.\t.\t.";
        print $O1 "$output\n";
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄