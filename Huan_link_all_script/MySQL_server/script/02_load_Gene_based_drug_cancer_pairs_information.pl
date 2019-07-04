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
my $f1 = "/f/mulinlab/huan/ALL_result_ICGC_ALL_drug/output/19_gene_based_ICGC_somatic_repo_may_success_logic.txt";
open my $I1 , '<' , $f1 or die "$0 : failed to open input file '$f1' : $!\n";
# open( my $I1 ,"gzip -dc $f1|") or die ("can not open input file '$f1' \n"); #读压缩文件
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
    unless(/^Mutation_ID/){
        my $Mutation_ID =$f[0];
        my $Map_to_gene_level =$f[1];
        my $entrezgene =$f[2];
        my $project =$f[3];
        my $cancer_specific_affected_donors =$f[4];
        my $cancer_ID =$f[5];
        my $project_full_name =$f[6];
        my $project_full_name_from_project =$f[7];
        my $oncotree_term_detail =$f[8];
        my $oncotree_ID_detail =$f[9];
        my $oncotree_term_main_tissue =$f[10];
        my $oncotree_ID_main_tissue =$f[11];
        my $gene_role_in_cancer =$f[12];
        my $Drug_chembl_id_Drug_claim_primary_name =$f[13];
        my $Gene_symbol =$f[14];
        my $Entrez_id =$f[15];
        my $Interaction_types =$f[16];
        my $Drug_claim_primary_name =$f[17];
        my $Drug_chembl_id =$f[18];
        my $Max_phase =$f[19];
        my $First_approval =$f[20];
        my $Indication_class =$f[21];
        my $Drug_indication =$f[22];
        my $Drug_indication_source =$f[23];
        my $Clinical_phase =$f[24];
        my $Link_Refs =$f[25];
        my $Drug_indication_Indication_class =$f[26];
        my $ENSG_ID =$f[27];
        my $Final_source =$f[28];
        my $Indication_ID =$f[29];
        my $Drug_type =$f[30];
        my $DOID =$f[31];
        my $DO_term =$f[32];
        my $HPO_ID =$f[33];
        my $HPO_term =$f[34];
        my $indication_OncoTree_term_detail =$f[35];
        my $indication_OncoTree_IDs_detail =$f[36];
        my $indication_OncoTree_main_term =$f[37];
        my $indication_OncoTree_main_ID =$f[38];
        my $logic =$f[39];

        $Entrez_id =~s/NULL|NONE/NA/g;
        $ENSG_ID =~s/NULL|NONE/NA/g;
        $gene_role_in_cancer =~s/NULL|NONE/NA/g;
        my $k = "$Mutation_ID\t$Map_to_gene_level\t$Entrez_id\t$ENSG_ID\t$project\t$cancer_specific_affected_donors\t$gene_role_in_cancer";
        $k="$k\t$Drug_chembl_id_Drug_claim_primary_name\t$Drug_type\t$logic";
        unless(exists $hash1{$k}){
            $hash1{$k} =1;
            if ($Entrez_id eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($Entrez_id) 
            }
            if ($ENSG_ID eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($ENSG_ID) 
            }
            if ($gene_role_in_cancer eq "NA") { #这些值在mysql要按照空处理。在表里填NULL
                undef($gene_role_in_cancer)
            }
            $sth = $dbh -> prepare("insert into Gene_based_drug_cancer_pairs_information (Mutation_ID,Map_to_gene_level,entrezgene,ENSG_ID,
            project,cancer_specific_affected_donors,gene_role_in_cancer,Unique_drug_name,Drug_type,logic) 
                                    values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            $sth -> execute($Mutation_ID,$Map_to_gene_level,$Entrez_id,$ENSG_ID,$project,$cancer_specific_affected_donors,$gene_role_in_cancer,
            $Drug_chembl_id_Drug_claim_primary_name,$Drug_type,$logic); #开始插
            # $sth = $dbh -> prepare("insert into Gene_and_network_data_used_to_count_features (Mutation_ID,Map_to_gene_level,ENSG_ID,
            # project,cancer_specific_affected_donors,gene_role_in_cancer,Unique_drug_name,Drug_type,logic) 
            #                         values (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            # $sth -> execute($Mutation_ID,$Map_to_gene_level,$ENSG_ID,$project,$cancer_specific_affected_donors,$gene_role_in_cancer,
            # $Drug_chembl_id_Drug_claim_primary_name,$Drug_type,$logic); #开始插
        }
    }
}
$sth -> finish(); #插入完
$dbh->disconnect(); #断开连接
