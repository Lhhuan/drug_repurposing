#将01_all_drug_secondary_evidence_by_fda.txt和unique_secondary_indication_gene.txt联系起来，得有gene的repo disease文件:02_drug_secondary_evidence_by_fda_gene.txt，
#有gene的repo disease及其基因列表的文件，02_drug_secondary_evidence_by_fda_gene_list.txt, 没有gene的文件02_drug_secondary_evidence_by_fda_no_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./01_all_drug_secondary_evidence_by_fda.txt"; #包含drug_name，rxid，primary indication(文件header为source)和 secondary disease（文件header为target）的信息
my $f2 ="./unique_secondary_indication_gene.txt";#包含secondary disease和致病基因。
# my $f4 ="./curated_gene_disease_associations.tsv"; #包含repodisease_gene的关系。
my $fo1 ="./02_drug_secondary_evidence_by_fda_gene.txt"; #有gene的repo disease文件
my $fo2 = "./02_drug_secondary_evidence_by_fda_gene_list.txt";#有gene的repo disease及其基因列表的文件
my $fo3 = "./02_drug_secondary_evidence_by_fda_no_gene.txt"; #没有gene的文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
# open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
# open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

select $O1;
print "rxid\tname\tprimary\tsecondary\n"; 
select $O2;
print "rxid\tname\tprimary\tsecondary\tgene\tuniprot\tgene_full_name\tDPI\tDSI\tprotein_class\tscore\tEI\tnum_of_pmids\tnum_of_snps\n"; 
select $O3;
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^rxid/){
         for (my $i=0;$i<4;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
        unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
        }
        unless($f[3]=~/NA/){
         my $rxid = $f[0];
         my $name =$f[1];
         my $primary = $f[2];
         my $secondary = $f[3];
         $secondary = lc($secondary);
         $secondary =~ s/"//g;
         my $k = join("\t",@f[0..2]);
         push @{$hash1{$secondary}},$k;
        }
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
        my @disease_infos = @{$hash1{$disease}};
        my @disease_genes = @{$hash2{$disease}};
        foreach my $disease_info(@disease_infos){
            my $out1 = "$disease_info\t$disease";
            # my $out1 = "$disease";
            unless(exists $hash3{$out1}){
                print $O1 "$out1\n";
                $hash3{$out1}=1;
            }
            foreach my $disease_gene(@disease_genes){
                my $out2 = "$out1\t$disease_gene";
                # my $out2 = "$disease";
                unless(exists $hash4{$out2}){
                    print $O2 "$out2\n";
                    $hash4{$out2}=1;
                }
            }
        }
        
    } 
    else{
        my $out3 = $disease;
        unless(exists $hash5{$out3}){
            print $O3 "$out3\n";
        $hash5{$out3}=1;
        }
    }
}

