#将../output/02_merge_sample_oncotree_drug.txt 和"/f/mulinlab/huan/All_result_ICGC/21_all_drug_infos.txt" 通过Drug_claim_primary_name merge,得
#../output/021_merge_sample_oncotree_chembl.txt


my $f1 = "/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../output/02_merge_sample_oncotree_drug.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="../output/021_merge_sample_oncotree_chembl.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id = $f[0];
        my $Drug_claim_primary_name =$f[4];
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
        push @{$hash1{$Drug_claim_primary_name}},$Drug_chembl_id;
    }
}
while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if(/^ccl_name/){
        print $O1 "$_\tDrug_chembl_id_Drug_claim_primary_name\n";
    }
    else{
        my $drug = $f[5];
        my $Drug =$drug;
        $Drug =~s/\(.*?$//g;
        $Drug =uc($Drug);
        $Drug =~ s/"//g;
        $Drug =~ s/'//g;
        $Drug =~ s/\s+//g;
        $Drug =~ s/,//g;
        $Drug =~s/\&/+/g;
        $Drug =~s/\)//g;
        $Drug =~s/\//_/g;
        $Drug =~s/\.//g;
        $Drug =~s/\-//g;
        if (exists $hash1{$Drug}){
            my @chembls = @{$hash1{$Drug}};
            foreach my $chembl(@chembls){
                my $output1 = "$_\t$chembl";
                unless(exists $hash2{$output1}){
                    $hash2{$output1} =1;
                    print $O1 "$output1\n"; 
                }
            }
        }
        else{
            print STDERR "$drug\n";
        }
    }
}