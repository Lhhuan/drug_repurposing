#将./v4/output/all_sv_snv.vcf中cadd fre score >=15的筛选出来，得./v4/output/all_pathogenicity_sv_snv.vcf

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./v4/output/all_sv_snv.vcf";
my $fo1 = "./v4/output/all_pathogenicity_sv_snv.vcf";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


print $O1 "POS\tScore\tProject\tID\tSource\toccurance\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless  (/^POS/){
        my $pos = $f[0];
        my $score = $f[1];
        my $Project = $f[2];
        my $ID = $f[3];
        my $Source = $f[4];
        if($score>=15){
            my @projects = split/\,/,$Project;
            my $occurance = @projects;
            my %hash1;
            @projects =grep{++$hash1{$_}<2}@projects;
            my $pro = join (",",@projects);
            my $output = "$pos\t$score\t$pro\t$ID\t$Source\t$occurance";
            print $O1 "$output\n";
        }
        else{
            print "$_\n";
        }
    }
}

    # @drug_target_score_infos = grep { ++$hash14{$_} < 2 } @drug_target_score_infos; #对数组内元素去重