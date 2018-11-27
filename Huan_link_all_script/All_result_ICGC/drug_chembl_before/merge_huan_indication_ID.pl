#将huan_target_drug_indication.txt的indication的ID 追加到表的最后。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

# my $f1 ="./123.txt";
# my $f2 ="./234.txt";
my $f1 ="./huan_target_drug_indication.txt";
my $f2 ="./huan_used_mapin.txt";
my $fo1 ="./huan_target_drug_indication_1.txt"; #将DGIdb_all_target_drug_indication_trans.txt和CLUE_REPURPOSING_indication_target_trans.txt将写在一个文件里。
my $fo2 ="./error.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name\tGene_symbol";
$title ="$title\tGene_claim_name\tEntrez_id\tInteraction_claim_source\tMoa\tDrug_claim_name\tDrug_claim_primary_name";
$title = "$title\tDrug_name\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
#my $title = "chembl_id\tdrug_name\tmoa\tgene_symbol\tdisease_area\tindication\tphase\tensg_id";
select $O1;
print "$title\n";
select $O2;
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
while(<$I1>)
{
    chomp;
    my @f = split/\t/;
     unless(/^Drug_chembl_id/){
         #$f[18] =~s/"//g; #
         my $Drug_indication = $f[18];#是Drug_indication|Indication_class
         $Drug_indication =~s/"//g;
         $Drug_indication=lc($Drug_indication);#转换成小写。
        # $Drug_indication =~ s/($Drug_indication)/\L$1/gi;
         $Drug_indication =~ s/\(//g;
         $Drug_indication =~ s/\)*//g;
         my $v = join ("\t",@f[0..20]);
         push @{$hash1{$Drug_indication}},$v;
         
     }
}


while(<$I2>) #CLUE_REPURPOSING_indication_target_trans.txt文件不再对Drug_chembl_id|Drug_claim_primary_name\tDrug_chembl_id|Drug_claim_name（因为这两列不重要）进行专门的格式整理都以drug_name填充。
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $indication_id = $f[0];
         #$f[1] =~ s/"//g;
         my $indication = $f[1];
         $indication =~ s/"//g;
         $indication = lc($indication);
         #$indication =~ s/($indication)/\L$1/gi;
         $indication =~ s/\(//g;
         $indication =~ s/\)//g;
         $hash2{$indication} = $indication_id;
     }
}

foreach my $ID (sort keys %hash1){
    if (exists $hash2{$ID}){
        my $s = $hash2{$ID};
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            print $O1 "$v\t$s\n";
            #print $O1 "$v\t$ID\t$s\n";
        }
    }
    else {
        my @v =@{$hash1{$ID}};
        foreach my $v(@v){
            print $O1 "$v\tNA\n";
        }
        #print STDERR "$ID\n";
        print $O2 "$ID\n";
    }
}
