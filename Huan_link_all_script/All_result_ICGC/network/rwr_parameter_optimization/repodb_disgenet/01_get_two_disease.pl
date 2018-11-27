##将RepurposeDB_CGEA.txt，RepurposeDB_Triples.txt和RepurposeDB_Evidence_Types.txt三个文件merge 到一起，然后与包含repodisease_gene的关系curated_gene_disease_associations.tsv
#一起找出网络中调参用的start,end得文件01_test_start_end.txt和unique的end文件，01_unique_end.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./RepurposeDB_CGEA.txt"; #包含drug_name 和target的信息
my $f2 ="./RepurposeDB_Evidence_Types.txt";#包含rxid,drug_name, number_of_drug_target
my $f3 ="./RepurposeDB_Triples.txt"; #包含rxid， primary_disease, repo_disease
my $f4 ="./curated_gene_disease_associations.tsv"; #包含repodisease_gene的关系。
my $fo1 ="./01_drug_target2_repo_disease.txt"; #既有diaease也有gene
my $fo2 = "./01_nofPmid3_disease_gene.txt";
my $fo3 = "./01_NofPmids3_disease.txt";
my $fo4 = "./01_drug_target2_repodisease.txt"; #只有disease
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";

select $O1;
print "drug\ttarget_entrez\trepo_disease\tnum_of_target\n"; 
select $O2;
print "diseaseName\tgeneSymbol\n";
select $O3;
select $O4;
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^compound/){
         for (my $i=0;$i<16;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NA
           unless(defined $f[$i]){
               $f[$i] = "NA";
           }
               unless($f[$i]=~/\w/){$f[$i]="NA"}  #对文件进行处理，把所有定义的没有字符的都替换成NA
           }
         my $drug_name = $f[11];
         my $target_entrez = $f[14];
         my @t = split/:/,$target_entrez;
         foreach my $t(@t){
             unless($t=~/NA/){
                 #print STDERR "$t\n";
                 push@{$hash1{$drug_name}},$t;
             }
         }
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^RxID/){
         #my $RxID = $f[0];
         my $drug_name = $f[1];
         my $num_of_target = $f[6];
         if($num_of_target>1){  #drug原有的target
             $hash2{$drug_name}=$num_of_target;
            #  print $O3 "$drug_name\n";
         }
     }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^rxid/){
         #my $rxid = $f[0];
         my $drug_name = $f[1];
         my $primary_disease = $f[2];
         my $repo_disease = $f[3];
         $repo_disease = lc($repo_disease);
         push @{$hash3{$drug_name}},$repo_disease;
     }
}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
     unless(/^geneId/){
         #my $rxid = $f[0];
         my $geneSymbol = $f[1];
         my $diseaseName = $f[3];
         my $NofPmids = $f[5];
         if($NofPmids>2){  #至少有三篇以上的pmid支持
             $diseaseName = lc($diseaseName);
             print $O3 "$diseaseName\n";
             print $O2 "$diseaseName\t$geneSymbol\n";
             push @{$hash4{$diseaseName}},$geneSymbol;
         }
         
         

     }
}

foreach my $drug (sort keys %hash1){
    if (exists $hash2{$drug}){
        if (exists $hash3{$drug}){
            my @target_entrezs = @{$hash1{$drug}};
            my $num_of_target = $hash2{$drug};
            my @repo_diseases = @{$hash3{$drug}};
            foreach my $target_entrez(@target_entrezs){
                foreach my $repo_disease(@repo_diseases){
                    my $out = "$drug\t$target_entrez\t$repo_disease\t$num_of_target";
                    # print STDERR "$num_of_target\n";
                    print $O4 "$repo_disease\n";
                    print $O1 "$out\n";
                    # unless(exists $hash5{$out}){
                    #     print $O1 "$out\n";
                    #     $hash5{$out}=1;
                    # }
                    # foreach my $disease(sort keys %hash4){
                    #     if (exists $hash4{$repo_disease}){
                    #         my @disease_genes = @{$hash4{$repo_disease}};
                    #         foreach my $disease_gene(@disease_genes){
                    #             my $start_end = "$target_entrez\t$disease_gene";
                    #             # my $start_end = "$drug\t$target_entrez\t$repo_disease\t$num_of_target\t$disease_gene";
                    #             unless(exists $hash6{$start_end}){
                    #                     # print $O1 "$start_end\n";
                    #                     $hash6{$start_end}=1;
                    #             }

                    #             unless(exists $hash7{$disease_gene}){
                    #                 # print $O2 "$disease_gene\n";
                    #                 $hash7{$disease_gene}=1;
                    #             }
                    #          }
                        
                    #     }

                    # }

                }
            }
        }
        
    } 
}

