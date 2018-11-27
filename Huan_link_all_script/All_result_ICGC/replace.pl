#对unique_drug_type.txt文件的调节因子往抑制剂和拮抗剂的方向上靠，得文件repalce.final.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./unique_drug_type.txt";
my $fo1 ="./replace.final.txt"; #在three_source_gene_role_final.txt中加入ensg_id 一列。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";


select $O1;
# print "Chrom:pos.alt.ref\tMutation_id\tENSG_ID\tSymbol\tEntrez_ID\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    my $drug=$f[0];
    
    
    if($drug=~/suppressor|antagonist|inhibitor|blocker/){
         $drug =~s/\,/ , /g;
        if($drug=~/activator|sensitizer|stimulant/){
            print $O1 "$drug\tBoth\n";
        }
        elsif($drug=~/\bagonist\b/){
            print $O1 "$drug\tBoth\n";
        }
        else{
            print $O1 "$drug\tI\n";
        }
    }
    elsif($drug=~/activator|agonist|stimulator|stimulant|potentiator|positive|enhancer|inducer/){
        if($drug=~/inhibitor|blocker|antagonist/){
            print $O1 "$drug\tBoth\n";
        }
        else{
            print $O1 "$drug\tA\n";
        }

    }
    else{
        print $O1 "$drug\tUnknown\n";

    }
}

 









