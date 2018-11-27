#为04_drug_target_secondary.txt的secondary找到gene得文件05_get_drug_target_secondary_gene.txt,得没有gene的secondary文件05_get_drug_target_secondary_no_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./04_drug_target_secondary.txt"; 
my $f2 ="./02_drug_secondary_evidence_by_fda_gene_list.txt"; 
my $fo1 ="./05_get_drug_target_secondary_gene.txt"; #得有gene的secondary
my $fo2 = "./05_get_drug_target_secondary_no_gene.txt";#没有gene的secondary文件，这个文件理论上是空的。
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "drug_name\tdrug_symbol\tdrug_entrez_ID\tprimary\tsecondary\tgene\tscore\n"; 
select $O2;
# print "rxid\tname\tprimary\tsecondary\n"; 
# # print "rxid\tname\tprimary\tsecondary\tgene\tuniprot\tgene_full_name\tDPI\tDSI\tprotein_class\tscore\tEI\tnum_of_pmids\tnum_of_snps"; 
# select $O3;
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name/){
         my $drug =$f[0];
         my $drug_symbol = $f[1];
         my $drug_entrez_ID = $f[2];
         my $primary = $f[3];
         my $secondary = $f[4];
         my $v = join("\t",@f[0..3]);
         push @{$hash1{$secondary}},$v;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^rxid/){
         my $secondary = $f[3];
         my $gene =$f[4];
         my $score = $f[10];
         if ($score>=0.001){  #为了避免自己把<0.001的数据放进源文件，也方便以后卡gene score的时候，直接改数值。
             my $v = "$gene\t$score";
            push @{$hash2{$secondary}},$v;
         }
     }
}


foreach my $secondary (sort keys %hash1){
    if (exists $hash2{$secondary}){
        my @drug_infos = @{$hash1{$secondary}};
        my @disease_genes = @{$hash2{$secondary}};
        foreach my $drug_info(@drug_infos){
            foreach my $disease_gene(@disease_genes){
                my $out1= "$drug_info\t$secondary\t$disease_gene";
                unless(exists $hash3{$out1}){
                    print $O1 "$out1\n";
                    $hash3{$out1}=1;
                }
            }
        }
    }
    else{
        my $out2 = $secondary;
        unless(exists $hash4{$out2}){
            print $O2 "$out2\n";
            $hash4{$out2}=1;
        }
    }
}
