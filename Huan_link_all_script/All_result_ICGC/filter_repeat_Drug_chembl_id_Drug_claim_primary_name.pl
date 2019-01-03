#因为dgidb中的药物收集来源于多个数据库，所以huan_target_drug_indication_final_symbol_drug-class.txt中有的同一Drug_claim_primary_name的chembl 有的是NA,有的是chembl ID，
#这样同一个药物就对应两个Drug_claim_primary_name_Drug_chembl_id,所以在这里进行去重，留下有chembl id的Drug_claim_primary_name_Drug_chembl_id，得unique_Drug_claim_primary_name_Drug_chembl_id.txt
#Drug_claim_primary_name_Drug_chembl_id这列，有chembl按照chembl输出，没有chembl按照Drug_claim_primary_name输出。
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_target_drug_indication_final_symbol_drug-class.txt";
my $fo1 ="./unique_Drug_claim_primary_name_Drug_chembl_id.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $title = "Drug_chembl_id|Drug_claim_primary_name\tDrug_claim_primary_name\tDrug_chembl_id";  
print $O1 "$title\n";
my %hash1;
my %hash3;
my %hash4;
my %hash5;

while(<$I1>)
{
    chomp;
    my $info = $_;
    $info =~ s/"//g;
    my @f= split /\t/,$info;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name = $f[4];
        my $Drug_chembl_id = $f[5];
        push @{$hash1{$Drug_claim_primary_name}},$Drug_chembl_id;
    }
}

my $length = keys %hash1;  #查看数组内key的个数
print STDERR "$length\n";   


foreach my $Drug_claim_primary_name(sort keys %hash1){
    my @Drug_chembl_ids = @{$hash1{$Drug_claim_primary_name}};
    my %hash2;
    @Drug_chembl_ids = grep { ++$hash2{$_} < 2 } @Drug_chembl_ids;
    my $num = @Drug_chembl_ids;
    if ($num eq 1){ #数组长度为1，即一个$Drug_claim_primary_name只有一行chembl
        my $Drug_chembl_id =$Drug_chembl_ids[0];
        if ($Drug_chembl_id =~/^CHEMBL/){  #有chembl按照chembl填充
            my $out = "$Drug_chembl_id\t$Drug_claim_primary_name\t$Drug_chembl_id";
            unless(exists $hash5{$out}){
                $hash5{$out} =1;
                print $O1 "$out\n";
            }
        }
        else{  #没有chembl按照$Drug_claim_primary_name填充
            my $out = "$Drug_claim_primary_name\t$Drug_claim_primary_name\t$Drug_chembl_id";
            unless(exists $hash5{$out}){
                $hash5{$out} =1;
                print $O1 "$out\n";
            }
        }
    }
    else{ #数组长度不为1，即一个$Drug_claim_primary_name有多chembl
        my @chembls=();
        foreach my $Drug_chembl_id(@Drug_chembl_ids){ #chembl 中有多行的，输出有chembl id的
            if ($Drug_chembl_id=~/^CHEMBL/){ #有的一个Drug_claim_primary_name对应多个chembl id,这些chembl id以逗号分隔，输出一条记录,在下面输出
                push @chembls,$Drug_chembl_id; 
                $hash4{$Drug_claim_primary_name} =1; #如果有chembl, 就把$Drug_claim_primary_name 放进hash4
            }
        }
        if (exists $hash4{$Drug_claim_primary_name}){ #如果$Drug_claim_primary_name在hash4,就输出在数组里的值
            my $chembl_num = @chembls;
            my $chembl_out = join (",",@chembls); #有的一个Drug_claim_primary_name对应多个chembl id,这些chembl id以逗号分隔，输出一条记录
            my $out1 = "$chembl_out\t$Drug_claim_primary_name\t$chembl_out";
            unless(exists $hash5{$out1}){
                $hash5{$out1} =1;
                print $O1 "$out1\n";
            }    
        }
        else{ #如果$Drug_claim_primary_name不在hash4，也就是没有chembl，chembl就是NA
            my $out = "$Drug_claim_primary_name\t$Drug_claim_primary_name\tNA";
                unless(exists $hash5{$out}){
                    $hash5{$out} =1;
                    print $O1 "$out\n";
                }
        }
        
    }

}

