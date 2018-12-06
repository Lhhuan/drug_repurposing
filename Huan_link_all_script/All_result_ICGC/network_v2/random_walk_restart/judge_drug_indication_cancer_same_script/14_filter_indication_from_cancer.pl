#把13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt文件在indication里出现的cancer滤掉（一整行滤掉），得得文件有可能repo成功的repo drug pairs 文件14_drug_repo_cancer_pairs_may_success.txt 得drug不可以repo的cancer(是drug本来治疗的cancer)文件14_drug_repo_cancer_pairs_may_fail.txt
#!/usr/bin/perl
use warnings;
use strict;
use utf8;  



my $f1 ="./13_network_based_ICGC_somatic_repo_indication_cancer_differ.txt";
#my $f1 ="./123.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";

my $fo1 ="./14_drug_repo_cancer_pairs_may_success.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./14_drug_repo_cancer_pairs_may_fail.txt"; 
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $title = "drug\trepo_cancer";
print $O1 "$title\n";
print $O2 "drug\tindication\n";


my (%hash1,%hash2,%hash3,%hash4);
while(<$I1>)
{
    chomp;
    unless(/^drug_name_network/){
        my @f= split /\t/;
        my $drug = $f[20];
        my $indications = $f[-2];
        $indications =~ s/"//g;
        my $cancer = $f[18];
        my @f2 = split/\;/,$indications; #因为一个drug可能多个Indication
        foreach my $indication(@f2){ 
            my $k = "$drug\t$indication\t$cancer";
            push @{$hash1{$drug}},$indication;
            push @{$hash2{$drug}},$cancer;
        }
    }
}

foreach my $drug (sort keys %hash1){
    my @indications = @{$hash1{$drug}};
    my %hash5;
     @indications = grep { ++$hash5{$_} < 2 } @indications;  #对数组内元素去重
    my @cancers = @{$hash2{$drug}};
    my %hash6;
    @cancers = grep { ++$hash6{$_} < 2 } @cancers;  #对数组内元素去重
    my $num =  @cancers ;
    #print STDERR "$num\n";
    foreach my $cancer(@cancers){
        if(grep /$cancer/, @indications ){  #捕获在indication里没有出现的cancer
         my $out = "$drug\t$cancer";
         unless(exists $hash3{$out}){
             $hash3{$out}=1;
             print $O2 "$out\n";
         }
        }
        else{
            my $out = "$drug\t$cancer";
            unless(exists $hash4{$out}){
                $hash4{$out}=1;
                print $O1 "$out\n";
         }
        }
       
    }
    
}


