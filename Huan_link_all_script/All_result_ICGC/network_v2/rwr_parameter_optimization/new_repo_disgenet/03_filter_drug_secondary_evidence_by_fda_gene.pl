#筛选出02_sorted_drug_secondary_evidence_by_fda_gene.txt drug primary和secondary 不一样的drug。得03_filter_drug_secondary_evidence_by_fda_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./02_sorted_drug_secondary_evidence_by_fda_gene.txt"; 
my $fo1 ="./03_filter_drug_secondary_ne_primary_evidence_by_fda_gene.txt"; #得secondary不等于primary文件
my $fo2 = "./03_secondary_eq_primary.txt";#得secondary等于primary文件
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "rxid\tname\tprimary\tsecondary\tsecondary_num\n"; 
select $O2;
print "rxid\tname\tprimary\tsecondary\n"; 
# print "rxid\tname\tprimary\tsecondary\tgene\tuniprot\tgene_full_name\tDPI\tDSI\tprotein_class\tscore\tEI\tnum_of_pmids\tnum_of_snps"; 
# select $O3;
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
         $primary = lc($primary);
         $primary =~ s/"//g;
         my $k = "$name\t$secondary" ;
        #  my $k = join("\t",@f[0..2]);
         push @{$hash1{$rxid}},$primary;
         push @{$hash2{$rxid}},$k;
        }
     }
}

foreach my $rxid (sort keys %hash1){
    if (exists $hash2{$rxid}){
        my @primarys = @{$hash1{$rxid}};
        my @secondary_infos = @{$hash2{$rxid}};
         @secondary_infos = grep { ++$hash5{$_} < 2 }  @secondary_infos; #对数组去重
        foreach my $primary(@primarys){
            my $number = @secondary_infos;
            foreach my $secondary_info(@secondary_infos){
                my @f= split/\t/,$secondary_info;
                my $drug_name = $f[0];
                my $secondary = $f[1];
                if ($primary ne $secondary){ #不等于
                    my $out1 = "$rxid\t$drug_name\t$primary\t$secondary\t$number";
                    unless(exists $hash3{$out1}){
                        print $O1 "$out1\n";
                        $hash3{$out1}=1;
                    }
                }
                else{
                     my $out2 = "$rxid\t$drug_name\t$primary\t$secondary";
                     unless(exists $hash4{$out2}){
                        print $O2 "$out2\n";
                        $hash4{$out2}=1;
                    }
                }
            }
        }
    }
}

