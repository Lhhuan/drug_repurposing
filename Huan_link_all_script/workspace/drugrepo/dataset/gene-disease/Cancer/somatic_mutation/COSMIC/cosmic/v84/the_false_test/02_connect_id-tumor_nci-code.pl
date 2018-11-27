#把01_merge_coding_and_noncoding_id_tumor.txt和CosmicSample.tsv.gz以及classification.csv联系起来，得到mutation_id-id-tumour_nci-code_efo的关系，得文件02_mutation_id-id-tumour_nci-code_efo.txt。
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  

# my $f1 = "./123.txt";
# my $f2 = "./234.txt";
# my $f3 = "./456.txt";
my $f1 = "./01_merge_coding_and_noncoding_id_tumor.txt";
my $f2 = "./classification.txt";
my $f3 = "./CosmicSample.tsv";
my $fo1 = "./02_mutation_id-id-tumour_nci-code_efo.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
#open my $DATE, 'zcat CosmicSample.tsv.gz|' or die "zcat CosmicSample.tsv.gz $0: $!\n"; 
my $header = "ID_tumour\tmutation_id\tID_sample\tmutation_pos\tNCI_Code\tSite_Primary\tSite_Subtype1\tSite_Subtype2\tSite_Subtype3\tHistology\tHist_Subtype1";
$header = "$header\tHist_Subtype2\tHist_Subtype3\tSite_Primary_COSMIC\tSite_Subtype1_COSMIC\tSite_Subtype2_COSMIC\tSite_Subtype3_COSMIC\tHistology_COSMIC\tHist_Subtype1_COSMIC\tHist_Subtype2_COSMIC\tHist_Subtype3_COSMIC\tEFO";
select $O1;
print "$header\n";
my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID_sample/){
         for (my $i=0;$i<4;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
         unless($f[3]=~/NULL|NONE/){
             my $ID_sample = $f[0];
             my $ID_tumour = $f[1];
             my $mutation_id = $f[2];
             my $mutation_pos = $f[3];
             my $v = "$mutation_id\t$ID_sample\t$mutation_pos";
             push @{$hash1{$ID_tumour}},$v;
             #print "$ID_tumour\n";
             #print "$v\n";
         }
         
     }
}

while(<$I3>)
{   
    chomp;
    my @f= split /\t/;
    unless(/^sample_id/){
        my $ID_tumour = $f[2];
        my $nci_code = $f[37];
        $hash2{$ID_tumour}=$nci_code;
        #print "$nci_code\n";
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Cosmic_Phenotype_id/){
         for (my $i=0;$i<19;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
               unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
           }
         my $Site_Primary = $f[1];
         my $Site_Subtype1 = $f[2];
         my $Site_Subtype2 = $f[3];
         my $Site_Subtype3 = $f[4];
         my $Histology = $f[5];
         my $Hist_Subtype1 = $f[6];
         my $Hist_Subtype2 = $f[7];
         my $Hist_Subtype3 = $f[8];
         my $Site_Primary_COSMIC = $f[9];
         my $Site_Subtype1_COSMIC = $f[10];
         my $Site_Subtype2_COSMIC = $f[11];
         my $Site_Subtype3_COSMIC = $f[12];
         my $Histology_COSMIC = $f[13];
         my $Hist_Subtype1_COSMIC = $f[14];
         my $Hist_Subtype2_COSMIC = $f[15];
         my $Hist_Subtype3_COSMIC = $f[16];
         my $NCI_Code = $f[17];
         my $efo = $f[18];
         my $v=join ("\t",@f[1..16,18]);
         push @{$hash3{$NCI_Code}},$v;
     }
}


foreach my $key (sort keys %hash1){
    if (exists $hash2{$key}){
        my @value = @{$hash1{$key}};
        my $s = $hash2{$key};
        #print STDERR "####$s####\n";
        if (defined $s && exists $hash3{$s}){
            my @v1 = @{$hash3{$s}};
            foreach my $t(@value){
                foreach my $v1(@v1){
                    print $O1 "$key\t$t\t$s\t$v1\n";
                }
            }
        }  
    }
}