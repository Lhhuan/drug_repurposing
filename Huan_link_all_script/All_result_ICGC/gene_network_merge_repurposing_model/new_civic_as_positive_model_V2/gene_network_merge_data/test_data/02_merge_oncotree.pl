#将./output/01_filter_Sensitivity_clinical_significance.txt和./output/unqie_cancer_oncotree.txt merge到一起，得./output/02_Sensitivity_clinical_significance_oncotree.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/unqie_cancer_oncotree.txt";
my $f2 ="./output/01_filter_Sensitivity_clinical_significance.txt";
my $fo1 ="./output/02_Sensitivity_clinical_significance_oncotree.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4);
print  $O1 "oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt\tentrez_id\n";


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^disease/){
        my $cancer = $f[0];
        my $oncotree_main_tissue_ID = $f[4];
        my $oncotree_ID = join ("\t",@f[1..4]);
        unless($oncotree_main_tissue_ID =~/NA/){
            $hash1{$cancer}=$oncotree_ID;
        }
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
        }
    }
}




close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
