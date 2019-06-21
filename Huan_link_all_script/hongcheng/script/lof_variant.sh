feature=('stop_gained' 'frameshift_variant' 'stop_lost' 'start_lost')
rm ./B_sift_tmp/varient_lof.txt
touch ./B_sift_tmp/varient_lof.txt
for i in ${feature[@]}
do
    echo $i
    grep $i 01_dbNSFP_snv_vep_huan.vcf >> ./B_sift_tmp/varient_lof.txt
done
