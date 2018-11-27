#!/usr/bin/perl
use warnings;
use strict;
use utf8;

my $f1 ="./step13_chembl_unexist.txt";
my $f2 = "./interactions_v3.tsv";
my $f3 = "./clinical.trial-drug-indication.txt";  
my $fo1 = "./step13-1_drug-indication-exist.txt"; #在clinical.trial中存在适应症的药物
my $fo2 = "./step13-1_drug_no_indication.txt"; #在clinical.trials中不存在适应症的药物
my $fo3 = "./step13-1_no_drug-name.txt";#在interactions_v3.tsv中不中存在的drug_claim_primary_name(如果数据处理正确，这个文件中数据为空)
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
select $O1;
print"drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\tdrug_claim_primary_name\tdrug_indication\tphase\tNCDid\tdrug_indication_source\n";
select $O2;
print"drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\tdrug_claim_primary_name\n";
select $O3;
print "drug_claim_name\tdrug_stage\tinteraction_type\tinteraction_claim_source\n";
my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
   chomp;
   unless(/drug_claim_name/){
       my @f = split/\t/;
       my $drug_claim_name = $f[0];
       my $drug_stage = $f[1];
       my $interaction_type = $f[2];
       my $interaction_claim_source = $f[3];
       my $v1 = join "\t",@f[1..3];
       $hash1{$drug_claim_name}=$v1;
   }
}

while(<$I2>)
{
   chomp;
   unless(/^gene_name/){
       my @f = split/\t/;
       for (my $i=0;$i<9;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
           unless(defined $f[$i]){
               $f[$i] = "NONE";
           }
           unless($f[$i]=~/\w/){$f[$i]="NULL"}  #对文件进行处理，把所有定义的没有字符的都替换成NULL
       } 
       #my $drug_claim_name = $f[5];
       my $drug_claim_primary_name =$f[6]; #相比于step15.pl step16将my $drug_claim_name = $f[5]换成$drug_claim_primary_name =$f[6]
       my $drug_claim_name = $f[5];
       $hash2{$drug_claim_name}=$drug_claim_primary_name;
       }
}

while(<$I3>)
{
   chomp;
   my @f = split/\t/;
   my $NCDid = $f[0];
   my $phase = $f[2];
   my $drug_claim_primary_name = $f[3];
   my $drug_indication = $f[5];
   my $drug_indication_source = "clinical.trial";
   my $v3 = "$drug_indication\t$phase\t$NCDid\t$drug_indication_source";
   push @{$hash3{$drug_claim_primary_name}},$v3;
}

 foreach my $drug_claim_name(sort keys %hash1){
       if(exists $hash2{$drug_claim_name}){ 
            my $v1 = $hash1{$drug_claim_name};
            my $drug_claim_primary_name = $hash2{$drug_claim_name};
            if(exists $hash3{$drug_claim_primary_name}){
                my @v3 = @{$hash3{$drug_claim_primary_name}};
                foreach my $v3(@v3){
                    my $k4 = "$drug_claim_name\t$v1\t$drug_claim_primary_name\t$v3";
                    unless(exists$hash4{$k4}){
                        print $O1 "$k4\n";
                        $hash4{$k4} = 1;
                   }
                }
            }
            else{ 
                my $v1 = $hash1{$drug_claim_name};
                my $drug_claim_primary_name = $hash2{$drug_claim_name};
                my $k5 = "$drug_claim_name\t$v1\t$drug_claim_primary_name";
                unless(exists$hash5{$k5}){
                    print $O2 "$k5\n";
                    $hash5{$k5} = 1;
                }
            }
       }
       else{
            my $v1 = $hash1{$drug_claim_name};
            my $k6 ="$drug_claim_name\t$v1";
                unless(exists$hash6{$k6}){
                    print $O3 "$k6\n";
                    $hash6{$k6} = 1;
                }
       }
 }


close $I1 or warn "$0 : failed to close input file '$f1' : $!\n";
close $I2 or warn "$0 : failed to close input file '$f2' : $!\n";
close $I3 or warn "$0 : failed to close input file '$f3' : $!\n";
close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";
close $O3 or warn "$0 : failed to close output file '$fo3' : $!\n";


