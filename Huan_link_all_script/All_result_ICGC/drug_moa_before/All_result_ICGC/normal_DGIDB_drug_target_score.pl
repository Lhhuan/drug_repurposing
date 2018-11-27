#把DGIDB_drug_target_score.txt的name 进行normal ,(因为之前给sinan的文件中 repurpose hub没有严格按照有chembl的chembl填充，现在之前的文件已经修改好，
#所以这里要dui sinan 给的文件进行统一化，有chembl按照chembl填充，没有chembl的按照drug name填充,这里需要借助unique_drug_name1.txt )，得normal_DGIDB_drug_target_score.txt ,得check在网页上抓数据的文件check_DGIDB_drug_target_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./unique_drug_name1.txt";
my $f2 = "./DGIDB_drug_target_score.txt";
my $fo1 = "./check_DGIDB_drug_target_score.txt";
my $fo2 = "./normal_DGIDB_drug_target_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "Drug_chembl_id|Drug_claim_primary_name\tgene\tmoa\tscore\tchembl\n";
print $O2 "Drug_chembl_id|Drug_claim_primary_name\tgene\tmoa\tscore\n";
while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id|Drug_claim_primary_name/){
        my $drug_name =$f[0];
        $drug_name =~ s/\"//g;
        my $CHEMBL =$f[-1];
        $hash1{$drug_name} =$CHEMBL;
    }
}


while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    for (my $i=0;$i<7;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NONE";
        }
    unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    my $drug = $f[0];
    $drug =~ s/\"//g;
    my $gene= $f[1];
    $gene =~ s/\s+//;
    my $moa = $f[2];
    $moa =~ s/"//g;
    $moa =~ s/\s+//g;
    my $score = $f[5];
    my $other_drug_name= $f[6];
    my $v = "$gene\t$moa\t$score";
    push @{$hash2{$drug}},$v;
}
 foreach my $drug(sort keys %hash1){
     my $chembl = $hash1{$drug};
     if(exists$hash2{$drug}){
         my @target_infos = @{$hash2{$drug}};
         foreach my $target_info(@target_infos){
             print $O1 "$drug\t$target_info\t$chembl\n";
         }
     }
     else{
        print STDERR "$drug\n";
     }
 }

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f3 = "./check_DGIDB_drug_target_score.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless (/^Drug_chembl_id|Drug_claim_primary_name/){
        unless ($f[1]=~/NONE|NULL/){
            my $drug =$f[0];
            my $gene = $f[1];
            my $moa = $f[2];
            my $score = $f[3];
            my $chembl = $f[4];
            if($drug=~/^CHEMBL/){
                print $O2 "$drug\t$gene\t$moa\t$score\n";
            }
            else{
                if($chembl=~/^CHEMBL/){
                    print $O2 "$chembl\t$gene\t$moa\t$score\n";
                }
                else{
                    print $O2 "$drug\t$gene\t$moa\t$score\n";
                }
            }
            
        }
    }
}




# my $f1 = "./DGIDB_drug_target_score.txt";
# my $fo1 = "./normal_DGIDB_drug_target_score.txt";
# open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
# my (%hash1,%hash2,%hash3,%hash4);
# print $O1 "Drug_chembl_id|Drug_claim_primary_name\tgene\tmoa\tscore\n";
# while(<$I1>)
# {
#     chomp;
#     my @f= split/\t/;
#     for (my $i=0;$i<7;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
#         unless(defined $f[$i]){
#         $f[$i] = "NONE";
#         }
#     unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
#     }
#     unless ($f[1]=~/NONE|NULL/){
#         my $drug=$f[0];
#         my $gene= $f[1];
#         $gene =~s/\s+//g;
#         my $moa = $f[2];
#         my $score = $f[5];
#         my $other_drug_name= $f[6];
#         if ($other_drug_name=~/^CHEMBL/){
#             print $O1 "$other_drug_name\t$gene\t$moa\t$score\n";
#         }
#         else{
#             print $O1 "$drug\t$gene\t$moa\t$score\n";
#         }
#      }
# }
