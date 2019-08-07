#把 ../data/ctrp/v21.meta.per_cell_line.txt ../data/ctrp/v21.meta.per_compound.txt 和../data/ctrp/v21.data.auc_sensitivities.txt merge 在一起，
#得../output/011_sample_drug_auc.txt


my $f1 = "../data/ctrp/v21.meta.per_cell_line.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "../data/ctrp/v21.meta.per_compound.txt";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $f3 = "../data/ctrp/v21.data.auc_sensitivities.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 ="../output/011_sample_drug_auc.txt"; 
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^master_ccl_id/){
        my $master_ccl_id = $f[0];
        my $ccl_name =$f[1];
        $hash1{$master_ccl_id} = $ccl_name;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    unless(/^master_cpd_id/){
        my $master_cpd_id = $f[0];
        my $cpd_name =$f[1];
        $hash2{$master_cpd_id} = $cpd_name;
    }
}

while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    if(/^experiment_id/){
        print $O1 "$_\tcpd_name\tccl_name\n";
    }
    else{
        my $experiment_id = $f[0];
        my $area_under_curve = $f[1];
        my $master_cpd_id =$f[2];
        my $master_ccl_id = $f[3];
        if (exists $hash2{$master_cpd_id}){
            my $cpd_name = $hash2{$master_cpd_id};
            if(exists $hash1{$master_ccl_id}){
                my $ccl_name = $hash1{$master_ccl_id};
                print $O1 "$_\t$cpd_name\t$ccl_name\n";

            }
        }
        
    }
}