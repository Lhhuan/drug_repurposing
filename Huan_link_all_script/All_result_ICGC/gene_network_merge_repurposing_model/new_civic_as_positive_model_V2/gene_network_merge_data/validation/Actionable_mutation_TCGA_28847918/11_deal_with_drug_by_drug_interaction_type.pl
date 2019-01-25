#根据drug_interaction type，对./output/10_civic_merge_oncotree.txt中的drug进行处理，得./output/11_civic_sensitivity_oncotree_deal_drug.txt

#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/10_civic_merge_oncotree.txt";
my $fo1 ="./output/11_civic_sensitivity_oncotree_deal_drug.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my $output ="oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt";
$output = "$output\tentrez_id\tdrug_interaction_type";
print  $O1 "$output\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
       my $drug = $f[4];
       my $output1 = join ("\t",@f[0..3]);
       my $output2 = join ("\t", @f[5..17]);
       my $drug_interaction_type = $f[-1];
       if ($drug_interaction_type =~/NULL/){
           print $O1 "$_\n";
       }
       elsif($drug_interaction_type =~/Combination/){ #把联用的药物， 替换成 + 
           $drug =~s/,/ + /g;
            print $O1 "$output1\t$drug\t$output2\n";
       }
       else{
           if($drug_interaction_type =~/Substitutes/){ # 把可替代的药物分开输出
               my @vs = split/\,/,$drug;
               foreach my $v(@vs){
                   print $O1 "$output1\t$v\t$output2\n";
               }
           }
           else{
               print $O1 "$_\n"; #对 drug interaction type是Sequential 暂且不处理，按照原理的样子输出
           }
       }
    }
}

