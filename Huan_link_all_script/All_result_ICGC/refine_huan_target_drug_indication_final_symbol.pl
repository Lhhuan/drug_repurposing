#huan_target_drug_indication_final_symbol.txt中同一药物对于同一基因的MOA,有的数据库(如drugbank)记录NA，有的数据库(如TTD)记录inhibitor,
#所以从此处开始，不再记录Interaction_claim_source的来源，只记录总来源DGIdb,也不再记录Gene_claim_name等信息（Gene_claim_name、Drug_chembl_id|Drug_claim_name、Drug_claim_name,drug_name这可以反映Interaction_claim_source的来源）所以这个也要删掉，像刚刚的情况，则记录药物对某基因的moa(Interaction_types)为inhibitor，得文件DGIdb_all_target_drug_indication_refine_final.txt
#得moa 为na类的药物huan_target_drug_indication_final_symbol_moa_na.txt，moa不为na类的药物文件huan_target_drug_indication_final_symbol_moa_not_na.txt，最后得moa去重后的文件huan_target_drug_indication_final_symbol_refine.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./huan_target_drug_indication_final_symbol.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $fo1 ="./huan_target_drug_indication_final_symbol_moa_na.txt"; #MOA 是na|NULL|other|unknown的drug
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 ="./huan_target_drug_indication_final_symbol_moa_not_na.txt"; ##MOA 不是na|NULL|other|unknown的drug
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $header1 = "Drug_chembl_id|Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";   #从此处起不再输出Interaction_claim_source,Gene_claim_name、Drug_chembl_id|Drug_claim_name、Drug_claim_name，drug_name的信息，
$header1 ="$header1\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink|Refs\tDrug_indication|Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
print $O1 "$header1\n";
print $O2 "$header1\n";
my (%hash1,%hash2);
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Interaction_types = $f[6];
        my $Drug_chembl_id_or_Drug_claim_primary_name =$f[0];
        $Drug_chembl_id_or_Drug_claim_primary_name = uc($Drug_chembl_id_or_Drug_claim_primary_name) ; #转换成大写。
        my $Drug_claim_primary_name = $f[8];
        $Drug_claim_primary_name =uc($Drug_claim_primary_name);
        my $gene_name=$f[2];
        $gene_name = uc($gene_name);
        my $output = join("\t",$Drug_chembl_id_or_Drug_claim_primary_name,$gene_name,@f[4,6],$Drug_claim_primary_name,@f[10..21]);
        if($Interaction_types =~/na|NULL|other|unknown/){
            unless(exists $hash1{$output}){
                $hash1{$output}=1;
                print $O1 "$output\n";
            }
        }
        else{
            unless(exists $hash2{$output}){
                $hash2{$output}=1;
                print $O2 "$output\n";
            }
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n"; #关闭文件句柄

system "sed -i 's/\r//' huan_target_drug_indication_final_symbol_moa_not_na.txt ";

#对上面的DGIdb_all_target_drug_indication_refine_moa_not_na.txt和DGIdb_all_target_drug_indication_refine_moa_na.txt文件中，同一drug gene interaction type进行去重，如有inhibitor,na则记录inhibitor.
my $f2 ="./huan_target_drug_indication_final_symbol_moa_not_na.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 ="./huan_target_drug_indication_final_symbol_moa_na.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo3 ="./huan_target_drug_indication_final_symbol_refine.txt"; 
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
my (%hash3,%hash4,%hash5);
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_chembl_id/){
        print $O3 "$_\n";
    }
    else{
        my $Interaction_types = $f[3];
        my $k = join("\t",@f[0..2,4..16]);
        $hash3{$k}=$Interaction_types;
        print $O3 "$_\n";
    }
}

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Interaction_types = $f[3];
        my $k = join("\t",@f[0..2,4..16]);
        push @{$hash4{$k}},$Interaction_types;
    }
}

foreach my $drug_infos(sort keys %hash4){
    my @moa_nas=@{$hash4{$drug_infos}};
    unless (exists $hash3{$drug_infos}){ #没有记录inhibitor，activater等非NA的moa时，才以NA,NULL等一系列信息填充。
        foreach my $moa_na (@moa_nas){
            my @f= split/\t/,$drug_infos;
            my $output2 = join("\t",@f[0..2],$moa_na,@f[3..15]);#按照$I3的输入格式输出。
            unless(exists $hash5{$output2}){
                $hash5{$output2}=1;
                print $O3 "$output2\n";
            }
        }
    }
}


 