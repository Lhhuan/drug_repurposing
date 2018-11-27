#为review_drug_repo.txt在unique_secondary_indication_gene.txt寻找disease gene，得文件有gene的disease 06_get_review_repodisease_gene.txt，没有gene的disease文件 06_no_disease_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./review_drug_repo.txt"; #包含drug_name，rxid，primary indication(文件header为source)和 secondary disease（文件header为target）的信息
my $f2 ="./unique_secondary_indication_gene.txt";#包含secondary disease和致病基因。
# my $f4 ="./curated_gene_disease_associations.tsv"; #包含repodisease_gene的关系。
my $fo1 ="./06_get_review_repodisease_gene.txt"; #有gene的repo disease文件
my $fo2 = "./06_no_disease_gene.txt";#没有gene的文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
# open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
# open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "drug\tsecondary\tgene\tuniprot\tgene_full_name\tDPI\tDSI\tprotein_class\tscore\tEI\tnum_of_pmids\tnum_of_snps\n"; 
select $O2;
#print "rxid\tname\tprimary\tsecondary\tgene\tuniprot\tgene_full_name\tDPI\tDSI\tprotein_class\tscore\tEI\tnum_of_pmids\tnum_of_snps\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug/){
         my $drug=$f[0];
         my $secondary = $f[1];
         $secondary = lc($secondary);
         $secondary =~ s/"//g;
        #  my $k = join("\t",@f[0..2]);
         push @{$hash1{$secondary}},$drug;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^DISEASE/){
         my $DISEASE = $f[0];
         my $Gene = $f[1];
         unless($Gene=~/NA/){
             my $v2 = join("\t",@f[1..10]);
            $DISEASE = lc($DISEASE);
            # print STDERR "$DISEASE\n";
            $DISEASE =~ s/"//g;
            push@{$hash2{$DISEASE}},$v2;
         }
         
     }
}

foreach my $disease (sort keys %hash1){
    if (exists $hash2{$disease}){
        print STDERR "$disease\n";
        my @drugs = @{$hash1{$disease}};
        my @disease_genes = @{$hash2{$disease}};
        foreach my $drug(@drugs){
            my $out1 = "$drug\t$disease";
            foreach my $disease_gene(@disease_genes){
                my $out2 = "$out1\t$disease_gene";
                # my $out2 = "$disease";
                unless(exists $hash4{$out2}){
                    print $O1 "$out2\n";
                    $hash4{$out2}=1;
                }
            }
        }
        
    } 
    else{
        my $out3 = $disease;
        unless(exists $hash5{$out3}){
            print $O2 "$out3\n";
        $hash5{$out3}=1;
        }
    }
}

