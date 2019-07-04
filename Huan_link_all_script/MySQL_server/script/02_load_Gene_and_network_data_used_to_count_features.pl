#!/usr/bin/perl
use warnings;
use strict;
use File::Basename;
use DBI;
use Data::Dumper;
use Getopt::Long;

#mysql config cariables
our $database = "OncoRepo";
our $user     = "huan";
our $pw       = "mulinlab_huan";
our $dbh =
  DBI->connect( "DBI:mysql:$database;host=202.113.53.211", "$user", "$pw" )  #连接数据库
  || die "Could not connect to database: $DBI::errstr";

##connect to mysql 
# my $connection = $dbh;

# my $dir = "/f/mulinlab/zhanye/project/QTLdb/data_refgene";
my %hash1;
my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/gene_network_merge_repurposing_model/V14/huan_data/output/03_unique_merge_gene_based_and_network_based_data.txt.gz";
# open my $I , '<' , $fi or die "$0 : failed to open input file '$fi' : $!\n";
open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
my $sth;
while (<$I1>) {
    chomp;
    my @f = split/\t/;
    for (my $i=0;$i<20;$i++){ #对文件进行处理，把所有未定义的空格等都替换成NONE
        unless(defined $f[$i]){
        $f[$i] = "NA";
        }
        unless($f[$i]=~/\w/){$f[$i]="NA"} #对文件进行处理，把所有定义的没有字符的都替换成NULL
    }
    unless(/^Drug_chembl_id/){
        my $Drug_chembl_id_Drug_claim_primary_name = $f[0];
        my $drug_entrze = $f[1];
        $drug_entrze =~s/NONE|NULL/NA/g;
        my $drug_ENSG = $f[2];
        $drug_ENSG =~s/NONE|NULL/NA/g;
        my $drug_target_score = $f[3];
        my $end_entrze = $f[4];
        $end_entrze =~s/NONE|NULL/NA/g;
        my $the_shortest_path = $f[5];
        my $path_length = $f[6];
        my $normal_score_P = $f[7];
        my $Mutation_ID = $f[8];
        my $cancer_specific_affected_donors = $f[9];
        my $original_cancer_ID = $f[10];
        #--------------------------------------------
        my $CADD_MEANPHRED = $f[11];
        my $cancer_ENSG = $f[12];
        my $oncotree_ID_sub_tissue =$f[13];
        my $oncotree_ID_main_tissue =$f[14];
        my $the_final_logic = $f[15];
        my $Map_to_gene_level = $f[16];
        my $project = $f[17];
        my $map_to_gene_level_score = $f[18];
        my $data_source = $f[19];
        # my $k = "$Drug_chembl_id_Drug_claim_primary_name\t$drug_entrze\t$drug_ENSG\t$ENSG_ID\t$Interaction_types\t$Drug_type\t$Final_source\t$drug_target_score\t$PACTIVITY_median";
        # print "$k\n";
        if ($drug_entrze eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
            undef($drug_entrze) 
        }
        if ($drug_ENSG eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
            undef($drug_ENSG) 
        }
        if ($end_entrze eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
            undef($end_entrze)
        }
        if ($cancer_ENSG eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
            undef($cancer_ENSG) 
        }
        $sth = $dbh -> prepare("insert into Gene_and_network_data_used_to_count_features (Unique_drug_name,drug_entrze,drug_ENSG,drug_target_score,
        end_entrze,the_shortest_path,path_length,normal_score_P,Mutation_ID,cancer_specific_affected_donors,original_cancer_ID,CADD_MEANPHRED,cancer_ENSG,
        oncotree_ID_detail,oncotree_ID_main_tissue,the_final_logic,Map_to_gene_level,project,map_to_gene_level_score,data_source) 
                                values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $sth -> execute($Drug_chembl_id_Drug_claim_primary_name,$drug_entrze,$drug_ENSG,$drug_target_score,$end_entrze,$the_shortest_path,$path_length,$normal_score_P,$Mutation_ID,
        $cancer_specific_affected_donors,$original_cancer_ID,$CADD_MEANPHRED,$cancer_ENSG,$oncotree_ID_sub_tissue,$oncotree_ID_main_tissue,$the_final_logic,$Map_to_gene_level,$project,$map_to_gene_level_score,
        $data_source); #开始插
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
