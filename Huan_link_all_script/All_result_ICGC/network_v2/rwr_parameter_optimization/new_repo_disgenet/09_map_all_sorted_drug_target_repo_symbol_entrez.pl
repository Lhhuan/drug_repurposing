#把all_sorted_drug_target_repo_gene.txt的repo symbol换成entrez，得有entrez的文件09_all_sorted_drug_target_repo_symbol_entrez.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./all_sorted_drug_target_repo_gene.txt"; 
my $f2 ="./08_uni_repo_symbol_entrezid.txt";
my $fo1 ="./09_all_sorted_drug_target_repo_symbol_entrez.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

select $O1;
print "drug_name\tdrug_symbol\tdrug_entrez_ID\tsecondary\tdisease_symbol\tdisease_entrez_ID\n"; 

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

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
         my $v = join("\t",@f[0..3]);
        push @{$hash1{$repo_symbol}},$v;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^query/){
         my $symbol = $f[0];
         my $entrez = $f[4];
         unless($hash2{$symbol}){
             $hash2{$symbol}=$entrez;
         }
     }
}

foreach my $symbol (sort keys %hash1){
    if(exists $hash2{$symbol}){
         my @repo_infos = @{$hash1{$symbol}};
         my $entrez= $hash2{$symbol};
         foreach my $repo(@repo_infos){
             my @f= split/\t/,$repo;
             my $drug_target = $f[2];
             if($entrez ne $drug_target){ #如果start不等于end,数据证明，不存在start=end
                 my $output = "$repo\t$symbol\t$entrez";
                 unless(exists $hash3{$output}){
                        print $O1 "$output\n";
                        $hash3{$output}=1;
                }
             }
         }
    } 
}
