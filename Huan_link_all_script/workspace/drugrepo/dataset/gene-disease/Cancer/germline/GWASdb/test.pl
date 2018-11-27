#!/usr/bin/perl
use warnings;
use strict;


my $fi_snp_vep ="index-vep-single-indexsnp1";
my $fi_snp ="step2_result_index_pos_disease";
open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";
open my $fh_snp, '<', $fi_snp or die "$0 : failed to open input file '$fi_snp' : $!\n";

 my @f;
while(<$fh_snp_vep>)
{
    chomp;  
  push @f,$_;
}

 while(<$fh_snp>)
 {
     unless(/^INDEX/){
      chomp;  
       my @f1 = split /\t/;
       my $index = $f1[0]; 
       my $chrom = $f1[1];
       my $pos = $f1[2];
       my $ref = $f1[4];
       my $alt = $f1[5];
       
     foreach my $f(@f) {
         if($index eq $f ){
           #  print $index."\n"
          print $chrom." ".$pos." \. ".$ref." ".$alt." \. \. \."."\n"
       # print  $index."\t".$chrom." ".$pos." \. ".$ref." ".$alt." \. \. \."."\n"
        }
     }
   }
 }




#      if( $flag==0){print $_."\n"} 
#  }          

#  while(<$fh_snp_vep>)
# {
#   s/^\s+//g;
#     unless(/^SNP/){
#      chomp;  
#       my @f1 = split /\s+/;
#       my $SNP = $f1[0];
#       if ($f1[7]=~/NONE/){
#           print $f1[0]."\n"
#       }
#       }
#     }    
#     #   my @tags = split /\|/,$f1[7];
#     #    foreach my $tags (@tags){
#     #       print $SNP."\t".$tags."\n"
#     #    }    
#     }
#  }   




#看plink.tags.list-1E-5中哪些index snp对应的NONE
#   my $fi_snp_vep ="plink.tags.list-1E-5";
#   open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

 
#  while(<$fh_snp_vep>)
# {
#   s/^\s+//g;
#     unless(/^SNP/){
#      chomp;  
#       my @f1 = split /\s+/;
#       my $SNP = $f1[0];
#       if ($f1[7]=~/NONE/){
#           print $f1[0]."\n"
#       }
#       }
#     }    
#     #   my @tags = split /\|/,$f1[7];
#     #    foreach my $tags (@tags){
#     #       print $SNP."\t".$tags."\n"
#     #    }    
#     }
#  }   


#看plinkn没有对哪些index snp 进行extend。
# my $fi_snp_disease ="step2-result_test_proxy_1E-5";
#  my $fi_snp_vep ="plink-extend";

# open my $fh_snp_disease, '<', $fi_snp_disease or die "$0 : failed to open input file '$fi_snp_disease' : $!\n";
# open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

# my @f1;
# while(<$fh_snp_vep>)
# {
#     chomp;  
#   push @f1,$_;
# }

#  while(<$fh_snp_disease>)
#  {
#      chomp;  
#      my $flag = 0;
#      foreach my $f(@f1) {
#          if($_ eq $f ){
#          $flag++ ;
#         }
#      }
 
#      if( $flag==0){print $_."\n"} 
#  }          



#查看plink extend 出的结果有多少index-snp
#  my $fi_snp_vep ="plink.tags.list-1E-5";
#  open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

 
#  while(<$fh_snp_vep>)
# {
#   s/^\s+//g;
#     unless(/^SNP/){
#      chomp;  
#       my @f1 = split /\s+/;
#       my $SNP = $f1[0];
#       print $SNP."\n"
#     #   my @tags = split /\|/,$f1[7];
#     #    foreach my $tags (@tags){
#     #       print $SNP."\t".$tags."\n"
#     #    }    
#     }
#  }   


#看注释的index-snp-vep中有多少漏掉的。
# my $fi_snp_disease ="step2-result_test_proxy_1E-5";
#  my $fi_snp_vep ="index-vep-single-indexsnp";


# open my $fh_snp_disease, '<', $fi_snp_disease or die "$0 : failed to open input file '$fi_snp_disease' : $!\n";
# open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

# my @f1;
# while(<$fh_snp_vep>)
# {
#     chomp;  
#   push @f1,$_;
# }

#  while(<$fh_snp_disease>)
#  {
#      chomp;  
#      my $flag = 0;
#      foreach my $f(@f1) {
#          if($_ eq $f ){
#          $flag++ ;
#         }
#      }
 
#      if( $flag==0){print $_."\n"} 
#  }          
      




#查看index_snp_5E-1vep中所有的index-snp
#  my $fi_snp_vep ="index_snp_5E-1vep";
#  open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";

#  my $extend_snp;
#  my $k;
#  my %hash;
#  while(<$fh_snp_vep>)
#  {
#      chomp;  
#      unless(/^POS/){
#          unless(/^"Use/){
#       my @f1 = split /\t/;
#       print $f1[0]."\n"
#      #   unless (/^CHR/){
#      #        $extend_snp = $f1[1];
#      #     #   $k = $f1[0];
#      #        $k = join "\t", @f1[0,2..31];
#      #         $hash{$extend_snp}=$k;
#         }   
#  }
#  }


