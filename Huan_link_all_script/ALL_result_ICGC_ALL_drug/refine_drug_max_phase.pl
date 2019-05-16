#将./output/21_all_drug_infos.txt和./output/from_sinan_score.txt中的target score merge到一起，得./output/all_drug_infos_score.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/all_drug_infos_score1.txt";
my $fo1 ="./output/all_drug_infos_score.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $title = "Drug_chembl_id_Drug_claim_primary_name\tGene_symbol\tEntrez_id\tInteraction_types\tDrug_claim_primary_name";  
$title ="$title\tDrug_chembl_id\tMax_phase\tFirst_approval\tIndication_class\tDrug_indication\tDrug_indication_source\tClinical_phase\tLink_Refs\tDrug_indication_Indication_class\tENSG_ID\tFinal_source\tIndication_ID";
$title = "$title\tDrug_type\tDOID\tDO_term\tHPO_ID\tHPO_term\tindication_OncoTree_term_detail\tindication_OncoTree_IDs_detail\tindication_OncoTree_main_term\tindication_OncoTree_main_ID";
$title = "$title\tdrug_target_score";
print $O1 "$title\n";


my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/){
        my $Max_phase = $f[6];
        my $First_approval= $f[7];
        my $Clinical_phase = $f[11];
        $Clinical_phase =~s/N\/A/NA/g;
        $Clinical_phase =~ s/\s+//g;
        $Clinical_phase =~ s/^.*\///g; #Phase1/Phase2这种情况，留/后面的Phase2
        $Clinical_phase =~ s/^.*Phase//g;
        # print "$Max_phase\t$Clinical_phase\n";
        my $out1 = join("\t",@f[0..5]);
        my $out2 =join ("\t",@f[7..26]);
        if ($Max_phase=~/NA/){ #Max_phase 为NA, 
            if ($Clinical_phase=~/\d/){ #Clinical_phase匹配数字
                $Max_phase = $Clinical_phase; #$Max_phase 用$Clinical_phase填充
                print $O1 "$out1\t$Max_phase\t$out2\n";
            }
            else{
                print $O1 "$_\n";
            }
        }
        else{
            print $O1 "$_\n";
        }
        # print "$Max_phase\t$Clinical_phase\n";
    }
}
