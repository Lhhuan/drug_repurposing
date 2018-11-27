#统计ID_project.txt中每个project所对应的mutation id的数目，得文件project_id_num.txt，#并且给每个cancer一个id,得文件cancer_id.txt
#!/usr/bin/perl
use warnings;
use strict; 
use utf8;

my $f1 = "./ID_project.txt";
my $fo1 = "./project_country_id_num.txt";
my $fo4 = "./cancer_id.txt";
open my $I1, '<', $f1 or die "$0 : failed to open input file '$f1' : $!\n";
open my $O1, '>', $fo1 or die "$0 : failed to open output file '$fo1' : $!\n";
open my $O4, '>', $fo4 or die "$0 : failed to open output file '$fo4' : $!\n";
my (%hash1,%hash2,%hash3,%hash4);
print $O1 "project\tinvolve_mutationID_num\n";
print $O4 "term\toriginal_term\tcancer_ID\n";
while(<$I1>)
{
    chomp;
    unless (/^ID/){
        my @f = split/\t/;
        my $id=$f[0];
        my $project = $f[1];
        push @{$hash1{$project}},$id;
        # $project =~ s/-*$//g;  #把后面的country信息去掉
        # print STDERR "$project\n";
        my @new_p =split/\-/,$project;
        my $no_country = $new_p[0];
        #print STDERR "$no_country\n";
        push @{$hash2{$no_country}},$id;
        $hash3{$project}=$no_country;
     }
}

foreach my $project(sort keys %hash1){
    my @ids =  @{$hash1{$project}};
    my $num = @ids;
    print $O1 "$project\t$num\n";
}

# foreach my $project(sort keys %hash2){
#     my @ids =  @{$hash2{$project}};
#     my $num = @ids;
#     print $O2 "$project\t$num\n";
#     print $O3 "$project=$num\t$num\n";
# }

my $i =0;
foreach my $project(sort keys %hash3){
     $i=$i+1;
    my $no_country = $hash3{$project};
    my $out = "$no_country\t$project\tICGC${i}";#给每个cancer 一个id，同一种cancer,不同国家，是同一个id,
    unless(exists $hash4{$out}){
        $hash4{$out} =1;
        print $O4 "$out\n";
    }
}