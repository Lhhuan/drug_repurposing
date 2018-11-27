#!/usr/bin/perl
use warnings;
use strict;

my $fi_snp_disease ="ALL_snp-disease";
my $fi_snp_vep ="all-snp-5E-1-split-vep";


open my $fh_snp_disease, '<', $fi_snp_disease or die "$0 : failed to open input file '$fi_snp_disease' : $!\n";
open my $fh_snp_vep, '<', $fi_snp_vep or die "$0 : failed to open input file '$fi_snp_vep' : $!\n";



my $extend_snp;
my $k;
my %hash;
while(<$fh_snp_disease>)
{
    chomp;  
     my @f1 = split /\t/;
      unless (/^INDEX/){
           $extend_snp = $f1[1];
           $k = $f1[0];
          # $k = join "\t", @f1[0,2..31];
          # $hash{$extend_snp}=$k;
          push @{$hash{$extend_snp}},$k;
      }
}




while(<$fh_snp_vep>)
{
    chomp;
    my @f= split /\t/;
    unless(/^POS/){
          unless(/^"Use/){
              my $extend = $f[0];
              my $symble = $f[5];
              my $variant_type = $f[7];
              my $m = join "\t", @f[1..4,7];
              my $t =  join "\t", @f[1..7]; 
              foreach my $extend_snp (sort keys %hash){
                if(exists $hash{$extend}){
                    my @k = @{$hash{$extend}};
                   # $k = $hash{$extend};
                   foreach my $s(@k){
                    print $s."\n"
                    # if ($symble !~/^$/){
                    #     if ($variant_type =~ /SNV/i){
                    #        # print "$extend\t$t\t$k\n";
                           
                    #    }
                    #   else{print $extend."\t".$t."\t". $k."\n"
                    #   }
                    #   }
                    #   elsif ($variant_type =~ /SNV/i){
                    #      # print $extend."\t".$m."\t".$k."\n"
                    #    }
                    # #   else{ 
                    # #  # print $extend."\t".$m."\t". $k."\n"
                         }
                    }
                }
           }
   }
}
  
    





# my $extend_snp;
# my $k;
# my %hash;
# while(<$fh_snp_disease>)
# {
#     chomp;  
#      my @f1 = split /\t/;
#       unless (/^INDEX/){
#            $extend_snp = $f1[1];
#            $k = $f1[0];
#           # $k = join "\t", @f1[0,2..31];
#            $hash{$extend_snp}=$k;
#       }
# }




# while(<$fh_snp_vep>)
# {
#     chomp;
#     my @f= split /\t/;
#     # s/^\"//g;

#     unless(/^POS/){
#           unless(/^"Use/){
#               my $extend = $f[0];
#               my $symble = $f[5];
#               my $variant_type = $f[7];
#               my $m = join "\t", @f[1..4,7];
#               my $t =  join "\t", @f[1..7]; 
#                 if(exists $hash{$extend}){
#                     $k = $hash{$extend};
#                     print $k."\n"
#                     # if ($symble !~/^$/){
#                     #     if ($variant_type =~ /SNV/i){
#                     #        # print "$extend\t$t\t$k\n";
                           
#                     #    }
#                     #   else{print $extend."\t".$t."\t". $k."\n"
#                     #   }
#                     #   }
#                     #   elsif ($variant_type =~ /SNV/i){
#                     #      # print $extend."\t".$m."\t".$k."\n"
#                     #    }
#                     # #   else{ 
#                     # #  # print $extend."\t".$m."\t". $k."\n"
#                     # #     }
#                     }
#                 }
#            }
#  #  }
# }
  
    
