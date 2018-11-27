#把07_drug_taregt_cancer_gene_same_logic.txt 中logic 不为NA 的筛选出来，并把没有drug target score的补score 为1,得08_logic_not_no_drug_cancer_infos.txt，
#08_logic_not_no_drug_cancer_infos.txt中有些药物和cancer pair 是side effect,但是drug target和cancer gene 的逻辑却都是TRUE,此步骤把这些药物去掉，得文件08_logic_not_no_drug_cancer_infos_check.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
#-------------------------------------------------------------------------------------- #把07_drug_taregt_cancer_gene_same_logic.txt 中logic 不为NA 的筛选出来，得08_logic_not_no_drug_cancer_infos.txt，并把没有drug target score的补score 为1
my $f1 ="./07_drug_taregt_cancer_gene_same_logic.txt";
my $fo1 ="./08_logic_not_no_drug_cancer_infos.txt"; 
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";

my $header = "Drug_claim_primary_name\tgene_symbol\tEntrez_id\tmoa\tENSG_ID\tdrug_type\tDrug_target_score\tnormal_Drug_target_score\toncotree_detail_term\toncotree_detail_ID\toncotree_main_term\toncotree_main_ID\tside-effect_or_repo";
$header = "$header\tCADD_score\tmutation_id\tcancer_ensg\tmap_to_gene_level\tcancer_Entrez_id\tcancer_specific_affected_donors\trole_in_cancer\tlogic";
print $O1 "$header\n";

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $logic = $f[-1];
        unless($logic=~/no/){
            my $drug = $f[0];
            my $drug_target_score =$f[6];
            my $output1 = join("\t",@f[0..6]);
            my $output2 =join ("\t",@f[7..19]);
            if ($drug_target_score=~/NA/){
                print $O1 "$output1\t1\t$output2\n";
            }
            else{
                print $O1 "$output1\t$drug_target_score\t$output2\n";
            }
       
        }
    }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n"; 

#------------------------------------------------------------------ #08_logic_not_no_drug_cancer_infos.txt中有些药物和cancer pair 是side effect,但是drug target和cancer gene 的逻辑却都是TRUE,此步骤把这些药物去掉，得文件08_logic_not_no_drug_cancer_infos_check.txt
my $f2 ="./08_logic_not_no_drug_cancer_infos.txt";
my $fo2 ="./08_logic_not_no_drug_cancer_infos_check.txt"; 
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

print $O2 "Drug_claim_primary_name\tEntrez_id\tensg\tnormal_drug_target_score\toncotree_main_ID\trepo_or_side_effect\tmutation_id\tCADD_score\tmap_to_gene_level\tcancer_specific_affected_donors\tlogic\tmap_to_gene_score\n";
my (%hash1,%hash2,%hash3);

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
    unless(/^Drug_claim_primary_name/){
        my $drug = $f[0];
        my $Entrez_id = $f[2];
        my $ensg =$f[4];
        my $normal_drug_target_score =$f[7];
        my $oncotree_main_ID = $f[11]; 
        my $repo_or_side_effect = $f[12];
        my $CADD_score = $f[13];
        my $mutation_id = $f[14];
        my $map_to_gene_level = $f[-5];
        my $cancer_specific_affected_donors =$f[-3];
        my $logic = $f[-1];
        $logic =lc ($logic);
        my $k1 = "$drug\t$oncotree_main_ID";
        my $v3= "$drug\t$Entrez_id\t$ensg\t$normal_drug_target_score\t$oncotree_main_ID\t$repo_or_side_effect\t$mutation_id\t$CADD_score\t$map_to_gene_level\t$cancer_specific_affected_donors\t$logic";
        $hash1{$k1}=$repo_or_side_effect;
        push @{$hash2{$k1}},$logic;
        if($map_to_gene_level=~/Level1_protein_coding/){ #Level1_protein_coding 给score 为5
            my $v31 = "$v3\t5";
            push @{$hash3{$k1}},$v31;
        }
        elsif($map_to_gene_level=~/level2_enhancer_target/){ #level2_enhancer_target 给score 为3
            my $v31 = "$v3\t3";
            push @{$hash3{$k1}},$v31;
        }
        else{
            if($map_to_gene_level=~/level3.1/){ #level3.1 给score 为2
            my $v31 = "$v3\t2";
            push @{$hash3{$k1}},$v31;
            }
            elsif($map_to_gene_level=~/level3.2/){ #level3.2 给score 为1
            my $v31 = "$v3\t1";
            push @{$hash3{$k1}},$v31;
            }
        }
    }
}

foreach my $drug_cancer (sort keys %hash1){
    my $repo_or_side_effect = $hash1{$drug_cancer};
    my @logics = @{$hash2{$drug_cancer}};
    my @all_infos = @{$hash3{$drug_cancer}};
    my %hash4;
    @logics = grep { ++$hash4{$_} < 2 } @logics;
    my %hash5;
    @all_infos = grep { ++$hash5{$_} < 2 } @all_infos;
    my $num = @logics;
    if ($num eq 1){ #只有一个逻辑
        if($repo_or_side_effect =~/Side_effect/){  #是side_effect
        #print STDERR "$drug_cancer\t$num\t$logics[0]\t$repo_or_side_effect\n";
            unless($logics[0]=~/true/){ #输出逻辑不是TRUE的
                foreach my $all_info(@all_infos){
                    print $O2 "$all_info\n";
                }
            }
        }
        else{ #是repo
            unless($logics[0]=~/conflict/){#只有一种逻辑，并且逻辑是conflict的不输出
                foreach my $all_info(@all_infos){
                    print $O2 "$all_info\n";
                }
            }
        }
    }
    else{#有多个逻辑
        foreach my $all_info(@all_infos){
             print $O2 "$all_info\n";
        }
    }
}

#---------------------------------------------------------------------------------------