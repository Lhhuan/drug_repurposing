#将drugtarget大于等于2的repo文件01_drug_target2_repo_disease.txt，对其diease进行mapin，经处理得文件"./mapin/repodisease/01_repodisease_indication_do_term.txt"
#将nofPmid大于等于3的文件01_nofPmid3_disease_gene.txt对其diease进行mapin，经处理得文件"./mapin/disease_gene/01_NofPmids3_disease_indication_do_term.txt";
#两边disease取交集，得02_uni_repo_drug.txt"; #输出满足条件的药物，02_uni_start.txt"; ##输出满足条件的start，得02_uni_end.txt"; ##输出，满足条件的end，得02_uni_start_end.txt"; #输出，满足条件的start_end_pair
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./01_drug_target2_repo_disease.txt"; #包含drug_name 和target的信息
my $f2 ="./mapin/repodisease/01_repodisease_indication_do_term.txt";   #包含rxid,drug_name, number_of_drug_target
my $f3 ="./01_nofPmid3_disease_gene.txt"; #包含rxid， primary_disease, repo_disease
my $f4 ="./mapin/disease_gene/01_NofPmids3_disease_indication_do_term.txt"; #包含repodisease_gene的关系。
my $fo1 ="./02_drug_target2_repo_disease_mapin.txt"; #既有diaease也有gene
my $fo2 = "./02_nofPmid3_disease_gene_mapin.txt";
my $fo3 = "./02_uni_repo_drug.txt"; #输出满足条件的药物
my $fo4 = "./02_uni_start.txt"; ##输出满足条件的start
my $fo5 = "./02_uni_end.txt"; ##输出，满足条件的end
my $fo6 = "./02_uni_start_end.txt"; #输出，满足条件的start_end_pair
my $fo7 = "./02_uni_start_end_info.txt"; #只有满足条件的start_end_pair,及其附加的info
my $fo8 = "./02_uni_map_repo_disease.txt"; #map上的repo_disease
my $fo9 = "./02_uni_unmap_repo_disease.txt"; #no map上的repo_disease

open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $I3, '<', $f3 or die "$0 : failed to open input file '$f3' : $!\n";
open my $I4, '<', $f4 or die "$0 : failed to open input file '$f4' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";
open my $O3, '>', $fo3 or die "$0 : failed to open output file '$fo3' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
open my $O5, '>', $fo5 or die "$0 : failed to open output file '$fo5' : $!\n";
open my $O6, '>', $fo6 or die "$0 : failed to open output file '$fo6' : $!\n";
open my $O7, '>', $fo7 or die "$0 : failed to open output file '$fo7' : $!\n";
open my $O8, '>', $fo8 or die "$0 : failed to open output file '$fo8' : $!\n";
open my $O9, '>', $fo9 or die "$0 : failed to open output file '$fo9' : $!\n";


select $O1;
print "drug_name\ttarget_entrez\tnum_of_target\trepo_disease\tDO_ID\tDO_term\tused_match\n"; 
select $O2;
print "disease_gene\tdisease\tDO_ID\tDO_term\tused_match\n";
select $O3;
select $O4;
select $O5;
select $O6;
print "start\tend\n";
select $O7;
print "drug_name\tstart\(target\)\trepo_disease\tend\(disease_gene\)\n";

my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7,%hash8,%hash9,%hash10,%hash11,%hash12,%hash13,%hash14,%hash15);

while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug/){
         my $drug_name = $f[0];
         my $target_entrez = $f[1];
         my $repo_disease = $f[2];
         my $num_of_target = $f[3];
         my $t = "$drug_name\t$target_entrez\t$num_of_target";
         push@{$hash1{$repo_disease}},$t;
         
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $ID= $f[0];
         my $indication = $f[1];
          $indication =~s/"//g;
         my $DO_id = $f[2];
         my $DO_term = $f[3];
         my $used_match_term;
         if ($DO_id =~/NA|NONE/){
             $used_match_term = $indication;
            my $v= "$DO_id\t$DO_term\t$used_match_term";
            $hash2{$indication}=$v;
         }
         else{
              $used_match_term = $DO_id;
              my $v= "$DO_id\t$DO_term\t$used_match_term";
              $hash2{$indication}=$v;
         }
     }
}

foreach my $disease(sort keys %hash1){  #先把mapin信息纳入进来存到文件里
    if (exists $hash2{$disease}){
        my @disease_genes = @{$hash1{$disease}};
        my $mapin = $hash2{$disease};
        foreach my$disease_gene(@disease_genes){
            my $k = "$disease_gene\t$disease\t$mapin";
            # print $O1 "$k\n";
            unless(exists $hash5{$k}){
                        print $O1 "$k\n";
                        $hash5{$k}=1;
                    }
        }
    }
    # else{
    #     print STDERR "$disease\trepo\n";  #这里的匹配miss 掉一个疾病refractory anemia with excess blasts, refractory anemia with excess blasts in transformation，手动检索该疾病在disgeenet中不存在
    # }
}

close $O1 or warn "$0 : failed to close output file '$fo1' : $!\n";


while(<$I3>)
{
    chomp;
    my @f= split /\t/;
     unless(/^diseaseName/){
         my $diseaseName = $f[0];
         my $gene = $f[1];
         push @{$hash3{$diseaseName}},$gene;
     }
}

while(<$I4>)
{
    chomp;
    my @f= split /\t/;
     unless(/^ID/){
         my $ID= $f[0];
         my $indication = $f[1];
         $indication =~s/"//g;
         my $DO_id = $f[2];
         my $DO_term = $f[3];
         my $used_match_term;
         if ($DO_id =~/NA|NONE/){
             $used_match_term = $indication;
            my $v= "$DO_id\t$DO_term\t$used_match_term";
            $hash4{$indication}=$v;
         }
         else{
              $used_match_term = $DO_id;
              my $v= "$DO_id\t$DO_term\t$used_match_term";
              $hash4{$indication}=$v;
         }
     }
}


foreach my $disease(sort keys %hash3){
    if (exists $hash4{$disease}){
        my @disease_genes = @{$hash3{$disease}};
        my $mapin = $hash4{$disease};
        foreach my$disease_gene(@disease_genes){
            my $k = "$disease_gene\t$disease\t$mapin";
            # print $O2 "$k\n";
             unless(exists $hash6{$k}){
                        print $O2 "$k\n";
                        $hash6{$k}=1;
            }
        }
    }
    # else{
    #     print $O4 "$disease\n";
    # }
}
close $O2 or warn "$0 : failed to close output file '$fo2' : $!\n";

my $f5 ="./02_drug_target2_repo_disease_mapin.txt"; #既有diaease也有gene
my $f6 = "./02_nofPmid3_disease_gene_mapin.txt";
open my $I5, '<', $f5 or die "$0 : failed to open input file '$f5' : $!\n";
open my $I6, '<', $f6 or die "$0 : failed to open input file '$f6' : $!\n";


while(<$I5>)
{
    chomp;
    my @f= split /\t/;
     unless(/^drug_name/){
         my $drug_name = $f[0];
         my $target_entrez = $f[1];
         my $repo_disease = $f[3];
         my $num_of_target = $f[2];
         my $DO_id = $f[4];
         my $DO_term = $f[5];
         my $used_match = $f[6];
         my $t = join("\t",@f[0..5]);
         push@{$hash7{$used_match}},$t;
         
     }
}

while(<$I6>)
{
    chomp;
    my @f= split /\t/;
     unless(/^disease_gene/){
         my $disease_gene = $f[0];
         my $disease = $f[1];
         my $DO_ID = $f[3];
         my $DO_term = $f[2];
         my $used_match = $f[4];
         my $t = join("\t",@f[0..3]);
         push@{$hash8{$used_match}},$t;
         
     }
}

foreach my $repo_disease(sort keys %hash7){
    if (exists $hash8{$repo_disease}){
        # print STDERR "$repo_disease\n";
    my @gene_starts = @{$hash7{$repo_disease}};
    my @gene_ends = @{$hash8{$repo_disease}};
        foreach my $gene_start(@gene_starts){
            my @f= split/\t/,$gene_start;
            #print STDERR "@f\n";
            my $drug_name = $f[0];
            my $target_entrez = $f[1];
            my $repo_disease = $f[3];
            my $num_of_target = $f[2];
            my $DO_id = $f[4];
            my $DO_term = $f[5];
             unless(exists $hash9{$drug_name}){ #输出满足条件的药物
                        print $O3 "$drug_name\n";
                        $hash9{$drug_name}=1;
            }
             unless(exists $hash10{$target_entrez}){ #输出满足条件的start
                        print $O4 "$target_entrez\n";
                        $hash10{$target_entrez}=1;
            } 
            foreach my $gene_end(@gene_ends){
                my @p =split/\t/,$gene_end;
                my $end = $p[0];
                my $disease = $p[1];

                unless(exists $hash11{$end}){ #输出，满足条件的end
                    print $O5 "$end\n";
                    $hash11{$end}=1;
                } 
                my $start_end = "$target_entrez\t$end";
                 unless(exists $hash12{$start_end}){ #输出，满足条件的start_end_pair
                    print $O6 "$start_end\n";
                    $hash12{$start_end}=1;
                } 
               my $all_info = "$drug_name\t$target_entrez\t$repo_disease\t$end";
               unless(exists $hash13{$all_info}){ #输出，满足条件的start_end_pair的其他信息
                    print $O7 "$all_info\n";
                    $hash13{$all_info}=1;
                } 
                unless(exists $hash14{$repo_disease}){ #输出，满足条件的start_end_pair的其他信息
                    print $O8 "$repo_disease\n";
                    $hash14{$repo_disease}=1;
                } 
            }
        }
      
     }
     else{
        #  my @gene_starts = @{$hash7{$repo_disease}};
        #  my $drug_name = $f[0];
        # my $target_entrez = $f[1];
        # my  = $f[3];
        # my $num_of_target = $f[2];
        # my $DO_id = $f[4];
        # my $DO_term = $f[5];
        # my $out= "$repo_disease\t$DO_id"
        unless(exists $hash15{$repo_disease}){ #输出，满足条件的start_end_pair的其他信息
                    print $O9 "$repo_disease\n";
                    $hash15{$repo_disease}=1;
        } 

     }
}

