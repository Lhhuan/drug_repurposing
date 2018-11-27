#01_merge_all_fantom5_ENCODE_Roadmap_data.txt中的gene有的以ensg表示，有的以NM表示，此处将两者分开，得02_all_ensg.txt 02_all_NM.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./01_merge_all_fantom5_ENCODE_Roadmap_data.txt";
my $fo1 = "./02_all_ensg.txt";
my $fo2 = "./02_all_NM.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "region\tgene\tscore\tsource";
print $O1 "$title\n";
print $O2 "$title\n";

my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^region/){
        my $region =$f[0];
        my $gene =$f[1];
        my $score = $f[2];
        my $source = $f[3];
        if($gene=~/ENSG/){
            $gene =~s/\..*//g;
            #print STDERR "$gene\n";
            my $out = "$region\t$gene\t$score\t$source";
            unless(exists $hash1{$out}){
                $hash1{$out} =1;
                print $O1 "$out\n";
            }
        }
        elsif($gene=~/\$*%/){
            my @f1= split/\$*%/,$gene;
            foreach my $gene1(@f1){
                $gene1 =~s/\$.*//g;  #.*匹配 0 次或多次的任何字符
                my $out1 = "$region\t$gene1\t$score\t$source";
                unless(exists $hash2{$out1}){
                    $hash2{$out1} =1;
                    print $O2 "$out1\n";
                }
            }
        }
       else{
           $gene =~s/\$.*//g; 
            my $out1 = "$region\t$gene\t$score\t$source";
            unless(exists $hash2{$out1}){
                $hash2{$out1} =1;
                print $O2 "$out1\n";
            }
       }
        
      
    }
}
close $I1 or warn "$0 : failed to close output file '$f1' : $!\n";
