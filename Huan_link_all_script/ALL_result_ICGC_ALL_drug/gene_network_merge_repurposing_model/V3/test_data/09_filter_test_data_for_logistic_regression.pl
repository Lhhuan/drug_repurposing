#从./output/08_drug_primary_calculate_features_for_logistic_regression.txt过滤出./output/07_final_positive_amd_negative_sample.txt
#需要的feature，得./output/09_media_filter_test_data_for_logistic_regression.txt
#提取./output/09_media_filter_test_data_for_logistic_regression.txt中需要的feature，得 ./output/09_filter_test_data_for_logistic_regression_re.txt
# 后来发现./output/09_filter_test_data_for_logistic_regression_re.txt 中有的重复（drug cancer pair既是0，也是1，）,所以要把这些去掉,得./output/09_filter_test_data_for_logistic_regression.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./output/08_drug_primary_calculate_features_for_logistic_regression.txt";
my $f2 ="./output/07_final_positive_amd_negative_sample.txt";
my $fo1 ="./output/09_media_filter_test_data_for_logistic_regression.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    if(/^Drug_claim_primary_name/){
        print $O1 "$_\tdrug_repurposing\n";
    }
    else{
        $_ =~ s/^\s+//g;
        my $Drug_claim_primary_name = $f[0];
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);#为了避免同一种Drug_chembl_id_Drug_claim_primary_name 有两个名字A-B和AB而造成的重复，此处对Drug_chembl_id_Drug_claim_primary_name进行处理。
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
        $Drug_claim_primary_name =~s/\//_/g;
        $Drug_claim_primary_name =~s/\&/+/g; #把&替换+
        $Drug_claim_primary_name =~s/,//g;
        $Drug_claim_primary_name =~s/'//g;
        $Drug_claim_primary_name =~s/\.//g;
        $Drug_claim_primary_name =~s/\+//g;
        $Drug_claim_primary_name =~s/\;//g;
        $Drug_claim_primary_name =~s/\://g;
        my $cancer_oncotree_id= $f[3]; 
        my $k = "$Drug_claim_primary_name\t$cancer_oncotree_id";
        $hash1{$k} =$_;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^oncotree_term_detail/){
        my $Drug= $f[4];
        # $Drug =~s/\(.*?$//g;
        $Drug =uc($Drug);
        # $Drug =~ s/"//g;
        # $Drug =~ s/'//g;
        # $Drug =~ s/\s+//g;
        # $Drug =~ s/,//g;
        # $Drug =~s/\&/+/g;
        # $Drug =~s/\)//g;
        # $Drug =~s/\(//g;
        # $Drug =~s/\//_/g;
        $Drug =~s/{//g;
        $Drug =~s/}//g;
        $Drug =~s/"//g;
        $Drug =~s/\(//g;
        $Drug =~s/\)//g;
        $Drug =~s/\s+//g;
        $Drug =~s/-//g;
        $Drug =~s/_//g;
        $Drug =~s/\]//g;
        $Drug =~s/\[//g;
        $Drug =~s/\//_/g;
        $Drug =~s/\&/+/g; #把&替换+
        $Drug =~s/,//g;
        $Drug =~s/'//g;
        $Drug =~s/\.//g;
        $Drug =~s/\+//g;
        $Drug =~s/\;//g;
        $Drug =~s/\://g;
        my $oncotree_detail_ID= $f[1];
        my $oncotree_main_ID= $f[3];
        my $sample_type = $f[5];
        my $sample_value = $f[6];
        my $k1 = "$Drug\t$oncotree_detail_ID";
        my $k2= "$Drug\t$oncotree_main_ID";
        my $v = "$sample_value";
        # $hash2{$k2}=$v;
        # $hash3{$k3}=$v;
        if (exists $hash1{$k1}){
            my $features = $hash1{$k1};
            my $output = "$features\t$sample_value";
            print $O1 "$output\n";
        }
        else{
            if (exists $hash1{$k2}){
                my $features = $hash1{$k2};
                my $output = "$features\t$sample_value";
                print $O1 "$output\n";
            }
        }

    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; #关闭文件句柄

my $f3 ="./output/09_media_filter_test_data_for_logistic_regression.txt";
my $fo2 ="./output/09_filter_test_data_for_logistic_regression_re.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

while(<$I3>)
{
    chomp;
    my @f= split /\t/;
    my $k = join ("\t",@f[1..23]);
    unless (exists $hash4{$k}){
        $hash4{$k} =1;
        print $O2 "$k\n";
    }
}
close ($O2);
close ($O1);

#-----------------------------------------------------------# 后来发现./output/09_filter_test_data_for_logistic_regression_re.txt 中有的重复（drug cancer pair既是0，也是1，）,所以要把这些去掉,得./output/09_filter_test_data_for_logistic_regression.txt
my $f4 ="./output/09_filter_test_data_for_logistic_regression_re.txt";
my $fo3 ="./output/09_filter_test_data_for_logistic_regression.txt";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
    if (/^cancer_oncotree_id_type/){
        print $O3 "$_\n";
    }
    else{
        my $cancer_oncotree_id_type = $f[0];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[1];
        my $cancer_oncotree_id = $f[2];
        my $k = "$cancer_oncotree_id_type\t$Drug_chembl_id_Drug_claim_primary_name\t$cancer_oncotree_id";
        push @{$hash5{$k}},$_;
    }
}

foreach my $k(sort keys %hash5){
    my @vs = @{$hash5{$k}};
    my %hash7;
    @vs = grep {++$hash7{$_}<2} @vs;
    # @invs = grep { ++$hash36{$_} < 2 } @invs;
    my $num = @vs;
    unless($num>1){
        foreach my $v(@vs){
            print $O3 "$v\n";
        }
    }
}


