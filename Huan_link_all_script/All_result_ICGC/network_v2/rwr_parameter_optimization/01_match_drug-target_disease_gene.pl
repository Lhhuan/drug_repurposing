#对从http://www.disgenet.org/web/DisGeNET/menu/downloads和http://repurposedb.dudleylab.org/browseDrugs/收集的test gene,构造可能存在网络关系，得网络关系start_end.txt和gene的列表test_gene_list.txt。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="./123.txt";
# my $f2 ="./1234.txt";
# my $f3 ="./12345.txt"; 
my $f1 ="./drug_target.txt";
my $f2 ="./drug_repo-disease.txt";
my $f3 ="./disease_gene.txt";
my $fo1 ="./start_end.txt"; 
#my $fo2 = "./test_gene_list.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "target\tdisease_gene\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug = $f[0];
         my $target = $f[1];
         push @{$hash1{$drug}},$target;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug = $f[0];
         my $disease = $f[1];
         push @{$hash2{$drug}},$disease;
     }
}

my $i= 0;
while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^second_disease/){
         my $disease = $f[0];
         my $gene = $f[1];
         my $NofPmids = $f[3];
         #my $i= 0;
         if ($NofPmids>=3){ #disease_gene关系中有大于等于3篇的pmid支持我们才用来进行test。
             $i=$i+1;
             print STDERR "$i\n";
            push @{$hash3{$disease}},$gene;

         }
     }
}


foreach my $drug (sort keys %hash1){
    if (exists $hash2{$drug}){
        my @disease = @{$hash2{$drug}};
        my @target =@{$hash1{$drug}};
        foreach my $target(@target){
            foreach my $disease(@disease){
                foreach my $disease_repo (sort keys %hash3){
                    if ($disease_repo eq $disease){
                        my @disease_genes = @{$hash3{$disease}};
                        foreach my $disease_gene(@disease_genes){
                            unless($target eq $disease_gene){  #保证start和end不一样。才能用作网络中的验证数据
                                my $final = "$target\t$drug\t$disease_repo\t$disease_gene";
                                my $output = "$target\t$disease_gene";
                                unless(exists $hash4{$output}){
                                    print $O1 "$output\n";
                                    $hash4{$output}=1;
                                }
                            }
                        }

                    }
                    
                }
            }
          
        }
    } 
}
