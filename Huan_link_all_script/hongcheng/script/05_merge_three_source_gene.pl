#将../data/cancer_gene_census.txt ../data/oncokb_cancerGeneList.txt  和../data/cancermine_collated_and_ensg_symbol.txt merge到一起。得../output/05_three_source_gene.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="../data/cancer_gene_census.txt";
my $f2 ="../data/oncokb_cancerGeneList.txt";
my $f3 ="../data/cancermine_collated_and_ensg_symbol.txt";
my $fo1 ="../output/05_three_source_gene.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
print $O1 "Gene_symbol\tEntrez\tTumour_Types\tRole_in_Cancer\tSource\n";

my(%hash1,%hash2);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Gene/){
        my $symbol = $f[0];
        my $Entrez =$f[2];
        my $Somatic =$f[7];
        my $Tumour_Types_Somatic =$f[9];
        $Tumour_Types_Somatic =~ s/"//g; 
        my $Tumour_Types_Germline =$f[10];
        $Tumour_Types_Germline =~ s/"//g;
        my $Role_in_Cancer = $f[14];
        $Role_in_Cancer =~ s/"//g;
        unless ($Role_in_Cancer =~/\w/){
            $Role_in_Cancer ="NA";
        }
        if ($Tumour_Types_Somatic =~/\w/){ #Tumour_Types_Somatic不为空
            if ($Tumour_Types_Germline =~/\w/){#Tumour_Types_Germline 不为空
                my $tumor_type= "${Tumour_Types_Somatic},${Tumour_Types_Germline}";
                my $output= "$symbol\t$Entrez\t$tumor_type\t$Role_in_Cancer";
                unless(exists $hash1{$output}){
                    print $O1 "$output\tCOSMIC\n";
                }
            }
            else{ #Tumour_Types_Germline 为空
                my $tumor_type= $Tumour_Types_Somatic;
                my $output= "$symbol\t$Entrez\t$tumor_type\t$Role_in_Cancer";
                unless(exists $hash1{$output}){
                    print $O1 "$output\tCOSMIC\n";
                }
            }
        }
        else{#Tumour_Types_Somatic为空
            if ($Tumour_Types_Germline =~/\w/){#Tumour_Types_Germline 不为空
                my $tumor_type= $Tumour_Types_Germline;
                my $output= "$symbol\t$Entrez\t$tumor_type\t$Role_in_Cancer";
                unless(exists $hash1{$output}){
                    print $O1 "$output\tCOSMIC\n";
                }
            }
            else{ #Tumour_Types_Germline 为空
                my $tumor_type= "NA";
                my $output= "$symbol\t$Entrez\t$tumor_type\t$Role_in_Cancer";
                unless(exists $hash1{$output}){
                    print $O1 "$output\tCOSMIC\n";
                }
            }
        }
    }
}

while(<$I2>) #该文件里没有重复的基因 oncokb
{
    chomp;
    my @f= split /\t/;
    unless(/^Hugo|Other/){
        my $Symbol = $f[0];
        my $Entrez =$f[1];
        my $Oncogene =$f[4];
        my $TSG =$f[5];
        my $cgc = $f[-1]; #是否在cancer_gene_census中出现过
        my $Tumour_Types = "NA";
        my $output1 = "$Symbol\t$Entrez\t$Tumour_Types";
        unless($cgc =~/Yes/){ #在cancer_gene_census 中出现过的不在记录
        # print "$cgc\n";
            if ($TSG =~/Yes/){ #gene 是tsg
                if ($Oncogene =~/Yes/){
                    my $Role_in_Cancer = "TSG,Oncogene";
                    # print "$_\n";
                    print $O1 "$output1\t$Role_in_Cancer\toncokb\n";
                }
                else{ #不是Oncogene
                    my $Role_in_Cancer = "TSG";
                    print $O1 "$output1\t$Role_in_Cancer\toncokb\n";
                }
            }
            else{ #不是TSG
                if ($Oncogene =~/Yes/){
                    my $Role_in_Cancer = "Oncogene";
                    print $O1 "$output1\t$Role_in_Cancer\toncokb\n";
                }
                else{ #不是Oncogene
                    my $Role_in_Cancer = "NA";
                    print $O1 "$output1\t$Role_in_Cancer\toncokb\n";
                }
            }
        }
    }
}


while(<$I3>) 
{
    chomp;
    my @f= split /\t/;
    unless(/^role/){
        my $Symbol = $f[-1];
        my $Entrez =$f[1];
        my $cancer_gene_role =$f[0];
        $cancer_gene_role =~ s/GOF/Oncogene/g;
        $cancer_gene_role =~ s/LOF/TSG/g;
        my $tumor_type = $f[3];
        my $output = "$Symbol\t$Entrez\t$tumor_type\t$cancer_gene_role\tcancermine";
        print $O1 "$output\n";
    }
}
