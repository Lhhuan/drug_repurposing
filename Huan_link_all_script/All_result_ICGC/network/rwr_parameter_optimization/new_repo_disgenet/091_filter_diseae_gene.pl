#把09_all_sorted_drug_target_repo_symbol_entrez.txt的每个drug中，在drug target 中出现的gene，在repo disease gene中去掉，得091_filter_all_sorted_drug_target_repo_symbol_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./09_all_sorted_drug_target_repo_symbol_entrez.txt"; 
my $fo1 ="./091_filter_all_sorted_drug_target_repo_symbol_entrez.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "drug_name\tdrug_symbol\tdrug_entrez_ID\tsecondary\tdisease_symbol\tdisease_entrez_ID\n"; 

my(%hash1,%hash2,%hash3);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name/){
         my $drug = $f[0];
         my $drug_symbol = $f[1];
         my $drug_entrez = $f[2];
         my $repo = $f[3];
         my $repo_symbol = $f[4];
         my $repo_entrez = $f[5];
         my $v = join("\t",@f[0..5]);
        push @{$hash1{$drug}},$v;
        push @{$hash2{$drug}},$drug_entrez;
        push @{$hash3{$drug}},$repo_entrez;
     }
}

my %hash8;
foreach my $drug (sort keys %hash1){
    my %hash7;
    if(exists $hash2{$drug}){
         if(exists $hash3{$drug}){

            my @repo_infos = @{$hash1{$drug}};
            my %hash4;
            @repo_infos = grep { ++$hash4{$_} < 2 } @repo_infos;  #对数组内元素去重
            my @drug_entrez= @{$hash2{$drug}};
            my %hash5;
            @drug_entrez = grep { ++$hash5{$_} < 2 } @drug_entrez;  #对数组内元素去
            my @repo_entrez= @{$hash3{$drug}};
            my %hash6;
            @repo_entrez = grep { ++$hash6{$_} < 2 } @repo_entrez;  #对数组内元素去重
            foreach my $drug_e(@drug_entrez){
                   $hash7{$drug_e} =1;
            }
                foreach my $repo_e(@repo_entrez){ 
                    unless(exists $hash7{$repo_e}){  #在drug target 中出现的gene，在repo disease gene中去掉
                        foreach my $repo(@repo_infos){
                        my @f= split/\t/,$repo;
                        my $drug = $f[0];
                        my $drug_symbol = $f[1];
                        my $drug_entrez_id = $f[2];
                        my $repo = $f[3];
                        my $repo_symbol = $f[4];
                        my $repo_entrez_id = $f[5];
                        if ($repo_entrez_id eq $repo_e){
                            my $output = "$drug\t$drug_symbol\t$drug_entrez_id\t$repo\t$repo_symbol\t$repo_entrez_id";
                            unless(exists $hash8{$output}){
                                print $O1 "$output\n";
                                $hash8{$output}=1;
                            }
                        }

                        
                    }

                }
            }
         }
    } 
}
