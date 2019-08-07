#将../data/snv_indel.txt 转成gDNA形式的hgvsg,得../output/01_snv_indel_gDNA_hgvs.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../data/snv_indel.txt";
my $fo1 ="../output/01_snv_indel_gDNA_hgvs.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "cDNA\thgvsg\n";


my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>){
    chomp;
    my @t=split/:/;
    my $symbol = $t[0];
    my $mutation= $t[2];
    my @f= split/\_/,$mutation;
    if($symbol =~/^FGFR4/){
        my $final_cDNA = "FGFR4:c.873_874insCAGCTTCGGAGCCGACGGTTTCCCCTATGTGCA";
        my $final_mutation = "\'$final_cDNA\'"; #给变量加单引号
        my $hgvsg = transvar_results ($final_mutation); #调子程序，转transvar
        my $output = "$final_cDNA\t$hgvsg";
        print $O1 "$output\n";  
    }
    else{
    my $cDNA = $f[0];
    my $final_cDNA = "${symbol}:${cDNA}";
    my $final_mutation = "\'$final_cDNA\'"; #给变量加单引号
    my $hgvsg = transvar_results ($final_mutation);
    my $output = "$final_cDNA\t$hgvsg";
    print $O1 "$output\n";
    }
}

sub transvar_results {  #transvar 处理
    my ($variant) =@_;
    # print STDERR "$variant\n";
    my $transvar_results = readpipe ("transvar canno --ccds -i $variant | cut -f1,5 | sed -n '2p' ");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值,
    my @v = split/\s+/,$transvar_results;
    my $number = @v;
    if ($number>1){
        my $hgvss = $v[1];
        my @h = split/\//,$hgvss;
        my $hgvsg = $h[0];
        return $hgvsg;       
    }
    else{
        my $hgvsg = "NA";
        return $hgvsg; 
    }
}
