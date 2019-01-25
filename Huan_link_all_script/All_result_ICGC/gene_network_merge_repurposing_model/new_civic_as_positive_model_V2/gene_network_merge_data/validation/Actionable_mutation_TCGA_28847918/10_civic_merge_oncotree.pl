# 把./output/09_filter_Sensitivity_civic.txt 和../../test_data/output/unqie_cancer_oncotree.txt merge 到一起，得./output/10_civic_merge_oncotree.txt 
#这里是对../../test_data/02_merge_oncotree.pl 的改进
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../../test_data/output/unqie_cancer_oncotree.txt";
my $f2 ="./output/09_filter_Sensitivity_civic.txt";
my $fo1 ="./output/10_civic_merge_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
my $output ="oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt";
$output = "$output\tentrez_id\tdrug_interaction_type";
print  $O1 "$output\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^disease/){
        my $cancer = $f[0];
        my $oncotree_main_tissue_ID = $f[4];
        my $oncotree_ID = join ("\t",@f[1..4]);
        # unless($oncotree_main_tissue_ID =~/NA/){
            $hash1{$cancer}=$oncotree_ID;
        # }
    }
}


while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless (/^drug/){
        my $cancer = $f[1];
        if (exists $hash1{$cancer}){
            # print STDERR "$cancer\n";
            my $oncotree_ID = $hash1{$cancer};
            my $output = "$oncotree_ID\t$_";
            unless(exists $hash2{$output}){
                $hash2{$output}=1;
                print $O1 "$output\n";
            }
        }
        else{
           if ($cancer =~/^Wa/){ #Waldenstrom Macroglobulinemia的字符为乱码，匹配不上，所以用次策略
               my $oncotree_ID = "Waldenstrom Macroglobulinemia\tWM\tLymphoid\tLymphoid";
               my $output = "$oncotree_ID\t$_";
                unless(exists $hash2{$output}){
                    $hash2{$output}=1;
                    print $O1 "$output\n";
                }
           }
           else{
               print STDERR "$cancer\n";
           }
        }
    }
}




close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
