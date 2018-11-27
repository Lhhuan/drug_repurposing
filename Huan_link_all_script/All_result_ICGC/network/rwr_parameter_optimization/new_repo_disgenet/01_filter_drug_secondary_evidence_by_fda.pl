#把文件RepurposeDB_Triples.txt按照ID把FDA支持的drug_secondary筛选出来，得文件，01_drug_secondary_evidence_by_fda.txt,得到没有在RepurposeDB_Triples.txt中不存在的drug列表01_drug_no_in_repurposeDB.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;


my $f1 ="./RepurposeDB_Triples.txt";
my $f2 ="./drug_triples_supported_by_FDA.txt";
my $fo1 ="./01_drug_secondary_evidence_by_fda.txt"; 
my $fo2 = "./01_drug_no_in_repurposeDB.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $I2, '<', $f2 or die "$0 : failed to open input file '$f2' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O2, '>', $fo2 or die "$0 : failed to open output file '$fo2' : $!\n";

select $O1;
print "rxid\tname\tsource\ttarget\n"; 
my(%hash1,%hash2,%hash3,%hash4,%hash5,%hash6,%hash7);
select $O2;
while(<$I1>)
{
    chomp;
    my @f= split /\t/;
     unless(/^rxid/){
         my $rxid = $f[0];
         my $name = $f[1];
         my $source = $f[2];
         my $target = $f[3];
         my $v = join("\t",@f[1..3]);
         push @{$hash1{$rxid}},$v;
     }
}

while(<$I2>)
{
    chomp;
    my @f= split /\t/;
     unless(/^Drug/){
         my $rxid = $f[0];
         $hash2{$rxid}=1; 
     }
}

foreach my $rxid (sort keys %hash2){
    if (exists $hash1{$rxid}){
        my @vs =@{$hash1{$rxid}};
        foreach my $v(@vs){
            my $out ="$rxid\t$v";
            # my $out =$rxid;
            unless(exists $hash3{$out}){
                print $O1 "$out\n";
                $hash3{$out}=1;
            }
        }
    }
    else{
        print $O2 "$rxid\n";
    } 
}
