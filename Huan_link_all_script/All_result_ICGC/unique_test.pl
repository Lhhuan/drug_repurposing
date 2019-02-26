
my $f2 ="./all_drug_unique_status_media.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo2 ="./all_drug_unique_status.txt";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O2 "Drug_chembl_id_Drug_claim_primary_name\tMax_phase\tFirst_approval\n";
while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_chembl_id/)
    {
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $Max_phase = $f[1];
        $Max_phase =~ s/Launched/FDA approved/g;
        my $First_approval = $f[2];
        if ($First_approval=~/\d+/){
            print $O2 "$Drug_chembl_id_Drug_claim_primary_name\tFDA approved\t$First_approval\n";
        }
        else{
            print $O2 "$Drug_chembl_id_Drug_claim_primary_name\t$Max_phase\t$First_approval\n";
        }
    }
}