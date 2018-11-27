#metis分割文件
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;
my @parts;
# my $i = 40;
my $i;
for ($i = 40;$i<1001;$i=$i+10){
    #$i= $i+10;
    push @parts,$i;
}

foreach my $part (@parts){
    print "$part\n";
    system "/f/mulinlab/huan/tools/metis-5.1.0/bin/gpmetis original_network_metis_input.txt $part";
    system "/f/mulinlab/huan/tools/metis-5.1.0/bin/gpmetis w2_metis_input.txt $part";
} 