#用./output/04_no_overlap_drug.txt 提取
#"/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/data/Drug_list_gdsc_11_55_50 2019.tsv"中的信息，;
#和gdsc有交集 文件./output/041_overlap_drug.txt
##和gdsc没有交集"./output/041_no_overlap.txt"
#和gdsc有交集，和huan有交集 "./output/041_overlap_huan.txt"
#和gdsc有交集，和huan没有交集 "./output/041_no_overlap_huan.txt"
#得最终和huan 没有overlap的文件./output/04_final_no_overlap_data.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./output/04_no_overlap_drug.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
my $f2 = "/f/mulinlab/huan/All_result_ICGC/gene_network_merge_repurposing_model/new_civic_as_positive_model_V2/gene_network_merge_data/validation/TCGA_28847918/data/Drug_list_gdsc_11_55_50 2019.tsv";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
my $fo1 = "./output/041_overlap_drug.txt";#和gdsc有交集
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $fo2 = "./output/041_no_overlap.txt";#和gdsc没有交集
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
my $f3 = "/f/mulinlab/huan/All_result_ICGC/all_drug_infos_score.txt";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
my $fo3 = "./output/041_overlap_huan.txt"; #和gdsc有交集，和huan有交集
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";  #
my $fo4 = "./output/041_no_overlap_huan.txt"; #和gdsc有交集，和huan没有交集
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my $fo5 = "./output/041_no_overlap_huan_Synonyms.txt"; #和gdsc有交集，和huan没有交集#即在fo4的基础上加入了药物的同义词
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
print $O3 "Drug\tDrug_chembl_id|Drug_claim_primary_name\n";
print $O5 "Drug\tSynonyms\n";

my (%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash30);

while(<$I1>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id/){
        my $drug =$f[0];
        my $Drug_claim_primary_name =$drug;
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);
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
        $hash1{$Drug_claim_primary_name}=$drug;
    }
}

while(<$I2>)
{
    chomp;
    my @f= split/\t/;
    if (/drug_id/){
        print $O1 "$_\n";
    }
    else{
        for (my $i=0;$i<8;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NONE";
        }
        unless($f[$i]=~/\w/){$f[$i]="NULL"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
        }

        my $drug = $f[1];
        my $Drug_claim_primary_name =$drug;
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);
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
        my $v = join("\t",@f[0..7]);
        $v =~s/"//g;
        # print STDERR "$v\n";
        $hash2{$Drug_claim_primary_name}=$v;
    }
}


while(<$I3>)
{
    chomp;
    my @f= split/\t/;
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id = $f[0];
        my $Drug_claim_primary_name =$f[4];
        $Drug_claim_primary_name = uc($Drug_claim_primary_name);
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
        push @{$hash3{$Drug_claim_primary_name}},$Drug_chembl_id;
    }
}

foreach my $k(sort keys %hash1){
    if (exists $hash2{$k}){
        my $v = $hash2{$k}; #$v 是原来的drug name，没有变换之前的
        print $O1 "$v\n";#和gdsc有交集
        my @f=split/\t/,$v;
        my $sy= $f[2];
        my @f2 =split/,/,$sy;
        my $v1 = $hash1{$k};
        foreach my $Synonyms (@f2){
            push @{$hash5{$v1}},$Synonyms;
            my $Drug = $Synonyms;
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
            if (exists $hash3{$Drug}){
                my @chembls = @{$hash3{$Drug}};
                foreach my $chembl(@chembls){
                    my $output = "$v1\t$chembl";
                    $hash6{$v1}=1;
                    unless (exists $hash4{$output}){
                        $hash4{$output} =1;
                        print $O3 "$output\n";  #和gdsc有交集，和huan有交集
                    }
                }
            }
        }
    }
    else{
        my $v = $hash1{$k};##和gdsc没有交集
        print $O2 "$v\n";
    }
}


foreach my $k(sort keys %hash5){ #找和gdsc有交集，和huan没有交集的drug
    unless(exists $hash6{$k} ){
        # print STDERR "$k\n";
        print $O4 "$k\n";
        my @Sy = $hash5{$k};
        foreach my $Synonyms(@Sy){
            my $output = "$k\t$Synonyms";
            unless (exists $hash7{$output}){
                $hash7{$output} =1;
                print $O5 "$output\n";
            }
        }
    }
}

close($O1);
close($O2);
close($O3);
close($O4);

system "cat ./output/041_no_overlap_huan.txt ./output/041_no_overlap.txt >./output/04_final_no_overlap_data.txt ";