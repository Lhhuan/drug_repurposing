 #为./output/all_drug_infos_score.txt 中的drug 在"/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18_refine.txt" #找type,比如：biotech，small_molecule等
#得./output/all_drug_infos_score_type.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="/f/mulinlab/huan/workspace/drugrepo/dataset/drug-target/DrugBank/getfromdrugbank2017-12-18_refine.txt";
my $f2 ="./output/all_drug_infos_score.txt";
my $fo1 ="./output/all_drug_infos_score_type.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1, %hash2, %hash3,%hash4);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^name/){
        my $Drug_claim_primary_name =$f[0];
        my $drug_type = $f[5];
        my $chembl = $f[-1];
        # print STDERR "$Drug_claim_primary_name\n";
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\-//g;
        $Drug_claim_primary_name =~s/\,//g;
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        $hash1{$Drug_claim_primary_name} =$drug_type;
        $hash2{$chembl} =$drug_type;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id/){
        print $O1 "$_\tdrug_type\n";
    }
    else{
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Drug_claim_primary_name =$f[4];
        $Drug_claim_primary_name =~s/\(.*?$//g;
        $Drug_claim_primary_name =uc ($Drug_claim_primary_name);
        $Drug_claim_primary_name =~ s/"//g;
        $Drug_claim_primary_name =~ s/'//g;
        $Drug_claim_primary_name =~ s/,//g;
        $Drug_claim_primary_name =~ s/\s+//g;
        $Drug_claim_primary_name =~s/\&/+/g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\-//g;
        $Drug_claim_primary_name =~s/\,//g;
        $Drug_claim_primary_name =~s/{//g;
        $Drug_claim_primary_name =~s/}//g;
        $Drug_claim_primary_name =~s/"//g;
        $Drug_claim_primary_name =~s/\(//g;
        $Drug_claim_primary_name =~s/\)//g;
        $Drug_claim_primary_name =~s/\s+//g;
        $Drug_claim_primary_name =~s/-//g;
        $Drug_claim_primary_name =~s/_//g;
        $Drug_claim_primary_name =~s/\]//g;
        $Drug_claim_primary_name =~s/\[//g;
        push @{$hash3{$Drug_chembl_id_Drug_claim_primary_name}},$_;
        if (exists $hash2{$Drug_chembl_id_Drug_claim_primary_name}){
            my $drug_type = $hash2{$Drug_chembl_id_Drug_claim_primary_name};
            push @{$hash4{$Drug_chembl_id_Drug_claim_primary_name}},$drug_type;
        }
        else{
            if (exists $hash1{$Drug_claim_primary_name}){
                my $drug_type = $hash1{$Drug_claim_primary_name};
                 push @{$hash4{$Drug_chembl_id_Drug_claim_primary_name}},$drug_type;
            }
            # else{
            #     print $O1 "$_\tunclassified\n";
            # }
        }
    }
}

foreach my $Drug_chembl_id_Drug_claim_primary_name (sort keys %hash3){
    my @infos = @{$hash3{$Drug_chembl_id_Drug_claim_primary_name}};
    if (exists $hash4{$Drug_chembl_id_Drug_claim_primary_name}){
        my @types = @{$hash4{$Drug_chembl_id_Drug_claim_primary_name}};
        my %hash5;
        @types = grep { ++$hash5{$_} < 2 } @types;
        my $type_number = @types;
        foreach my $info(@infos){
            if ($type_number >1 ){ #由于一个chembl 对应多个drug name,所以有可能多个name 有不同的chembl。经过检查发现这种的drug就有一个，所以,把这个药物归为unclassified
                print $O1 "$info\tunclassified drug\n";
                print "$Drug_chembl_id_Drug_claim_primary_name\n";
            }
            else{
                print $O1 "$info\t$types[0]\n";
            }
        }
    }
    else{ #这些没有在drugbank中记录,所以输出unclassified
        foreach my $info(@infos){
            print $O1 "$info\tunclassified drug\n";
        }
    }
}




close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; 
