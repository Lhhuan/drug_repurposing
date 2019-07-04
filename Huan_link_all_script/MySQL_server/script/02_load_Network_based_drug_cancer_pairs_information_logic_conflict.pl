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
my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/network/random_walk_restart/output/16_judge_the_shortest_drug_target_cancer_gene_logic_conflict.txt.gz";
# open my $I1 , '<' , $f1 or die "$0 : failed to open input file '$f1' : $!\n";
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
    unless(/^the_shortest_path/){
        my $the_shortest_path = $f[0];
        my $path_logic =$f[1];
        my $path_length = $f[2];
        my $drug_name_network =$f[3];
        my $start_id =$f[4];
        my $start_entrez =$f[5];
        my $random_overlap_fact_end_id =$f[6];
        my $normal_score_P = $f[7];
        my $end_entrze = $f[8];
        my $CADD_MEANPHRED = $f[9];
        my $Mutation_ID = $f[10];
        my $cancer_ENSG = $f[11];
        my $map_to_gene_level = $f[12];
        my $project = $f[13];
        my $cancer_specific_affected_donors = $f[14];
        my $original_cancer_id = $f[15];
        my $oncotree_term_detail = $f[18];
        my $oncotree_ID_detail = $f[19];
        my $oncotree_term_main_tissue = $f[20];
        my $oncotree_ID_main_tissue =$f[21];
        my $gene_role_in_cancer =$f[22];
        my $Drug_chembl_id_Drug_claim_primary_name = $f[23];
        my $Drug_claim_primary_name= "unwrite" ;#为了不改动后面的脚本，所以在这里加一列空值.
        my $drug_entrze = $f[25];
        my $drug_ENSG = $f[26];
        my $Drug_type =$f[-4];
        my $drug_target_score = $f[-3];
        my $drug_target_network_id =$f[-2];
        my $the_final_logic = $f[-1];
        $gene_role_in_cancer =~s/NULL|NONE/NA/g;
        my $k= "$the_shortest_path\t$path_logic\t$path_length\t$drug_name_network\t$start_id\t$start_entrez\t$random_overlap_fact_end_id\t$normal_score_P";
        $k="$k\t$end_entrze\t$Mutation_ID\t$cancer_ENSG\t$map_to_gene_level\t$project\t$cancer_specific_affected_donors\t$gene_role_in_cancer\t$Drug_chembl_id_Drug_claim_primary_name";
        $k="$k\t$drug_entrze\t$drug_ENSG\t$Drug_type\t$drug_target_score\t$drug_target_network_id\t$the_final_logic";

            if ($cancer_ENSG eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($cancer_ENSG) 
            }
            if ($gene_role_in_cancer eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($gene_role_in_cancer) 
            }
            if ($drug_entrze eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($drug_entrze)
            }
            if ($drug_ENSG eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($drug_ENSG)
            }
            if ($drug_target_score eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($drug_target_score)
            }
            $sth = $dbh -> prepare("insert into Network_based_drug_cancer_pairs_information_logic_conflict (the_shortest_path,path_logic,path_length,drug_name_network,
            start_id,start_entrez,random_overlap_fact_end_id,normal_score_P,end_entrze,Mutation_ID,Cancer_ENSG_ID,Map_to_gene_level,project,cancer_specific_affected_donors,
            gene_role_in_cancer,Unique_drug_name,Entrez_id_drug_target,ENSG_ID_target,Drug_type,drug_target_score,drug_target_network_id,the_final_logic) 
                                    values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $sth -> execute($the_shortest_path,$path_logic,$path_length,$drug_name_network,$start_id,$start_entrez,$random_overlap_fact_end_id,$normal_score_P,
            $end_entrze,$Mutation_ID,$cancer_ENSG,$map_to_gene_level,$project,$cancer_specific_affected_donors,$gene_role_in_cancer,$Drug_chembl_id_Drug_claim_primary_name,
            $drug_entrze,$drug_ENSG,$Drug_type,$drug_target_score,$drug_target_network_id,$the_final_logic); #开始插
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
