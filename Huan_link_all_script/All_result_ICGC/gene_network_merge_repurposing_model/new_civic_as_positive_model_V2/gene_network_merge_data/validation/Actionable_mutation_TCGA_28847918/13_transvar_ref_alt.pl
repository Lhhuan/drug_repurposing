 #把区分./output/12_merge_civic_and_mtctscan_other_database.txt里面的突变类型是否可以用transvar 转换,得./output/13_transvar_ref_alt.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 ="./output/12_merge_civic_and_mtctscan_other_database.txt";
my $fo1 ="./output/13_transvar_ref_alt.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
my $output ="oncotree_term_detail\toncotree_ID_detail\toncotree_term_main_tissue\toncotree_main_tissue_ID\tdrug\tdisease\tclinical_significance\tgene\tvariant\tevidence_statement\tvariant_id\tchr\tstart\tend\tref\talt";
$output = "$output\tentrez_id\tdrug_interaction_type\tstd_mutation_super_class\tsource\tfinal_variant\thgvsg\thgvsg_source";
print  $O1 "$output\n";


my (%hash1,%hash2,%hash3,%hash4);


while(<$I1>)
{
    chomp;
    my @f= split /\t/;
    unless (/^oncotree_term_detail/){
        my $source = $f[-1];
        my $gene = $f[7];
        my $variant = $f[8];
        $variant =~s/^p\.//g;
        my $final_variant = "${gene}:p.${variant}";
        my $chr = $f[11];
        my $start = $f[12];
        my $end = $f[13];
        my $pos = $start;
        my $ref = $f[14];
        my $length_ref = length($ref);
        my $alt= $f[15];
        my $length_alt = length($alt);
        my $std_mutation_super_class = $f[-2];
        if ($source =~/Civic/){ 
            if ($start eq $end ){
                if ($ref !~/NULL/ && $alt !~/NULL/){ #civic 中 start == end时有hgvsg的用civic的信息。
                    if ($length_ref eq 1 && $length_alt eq 1){
                        my $hgvsg = "${chr}:g.${pos}${ref}>${alt}";
                        print $O1 "$_\t$final_variant\t$hgvsg\t$source\n";
                    }
                    else{  #ref alt 长度大于1时，用 transvar 获得 hgvsg
                      my $hgvsg = transvar_results ($final_variant);
                      print $O1 "$_\t$final_variant\t$hgvsg\ttransvar\n";
                    }
                }
                elsif($ref =~/NULL/ && $alt =~/NULL/){ #如果ref和alt都没有填写NA
                    print $O1 "$_\tNA\tNA\t$source\n";
                }
                else{ #ref 或者alt 有空，用 transvar试一试
                    my $hgvsg = transvar_results ($final_variant);
                    print $O1 "$_\t$final_variant\t$hgvsg\ttransvar\n";
                }
            }
            else{ #start不等于end
                if ($ref =~/NULL/ && $alt =~/NULL/){ #如果ref和alt都没有填写NA
                    print $O1 "$_\tNA\tNA\t$source\n";
                }
                else{
                    my $hgvsg = transvar_results ($final_variant);
                    print $O1 "$_\t$final_variant\t$hgvsg\ttransvar\n";
                }  
            }
        }
        else{ #非civic来源的
            if($std_mutation_super_class =~/NULL/){
                my $hgvsg = transvar_results ($final_variant);
                print $O1 "$_\t$final_variant\t$hgvsg\ttransvar\n";   
            }else{
                print $O1 "$_\tNA\tNA\t$source\n";
            }
        }
    }
}


sub transvar_results {  #transvar 处理
    my ($variant) =@_;
    # print STDERR "$variant\n";
    my $transvar_results = readpipe ("transvar panno -i $variant --ensembl | cut -f1,5 | sed -n '2p' ");  #得到perl system 的返回值，相当于 system "transvar panno -i $final_variant --ensembl | cut -f1,5"的返回值
    my @v = split/\s+/,$transvar_results;
    my $number = @v;
    if ($number>1){
        my $hgvss = $v[1];
        my @h = split/\//,$hgvss;
        my $hgvsg = $h[0];
        return $hgvsg;       
    }
    else{
        my $hgvsg = "NA";
        return $hgvsg; 
    }
}
