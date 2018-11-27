# This is the file for automatic finemapping **preparation** for PAINTOR v3.1
# After using this file, you still need to run PAINTOR yourself

# variable specification section
# you need to specify most variables again
# =================================================================================
# =================================================================================

# input variables
# =================================================================================
# the input file must be tab delimited
# its columns must be: chr pos rsid effect_allele baseline_allele effect_size se Pvalue Zscore
# make a new directory for finemapping and put the gwas file inside

# the file name
file_name="gwas_summary_temp_sorted"
# the folder address
folder_address="/g/hongcheng/ovary_cancer_survival_project/testing_finemapping_script/"
# the annotation file list, put the annotations' file addresses in it
annotation_paths_list="/g/hongcheng/ovary_cancer_survival_project/ovary_cancer_survival_GWAS/annotation_path_dir/overvall_cancer_annotation_paths"
# pvalue threshold used to filter loci, e.g., 5e-8 means only loci with at least one SNP whose
# P value < 5e-8 will be kept
pvalue_threshold=5e-8
ethnicity="EAS"
# variables generated based on input variables
gwas_loci_dir=${folder_address}split_loci/
gwas_filtered_loci_dir=${folder_address}filtered_loci/

# tools
# =================================================================================
# PAINTOR can be downloaded from https://github.com/gkichaev/PAINTOR_V3.0
# htslib can be downloaded from http://www.htslib.org/download/

# specify CalcLD_1KG_VCF.py from PAINTOR
LD_matrix_cal="/f/mulinlab/huan/tools/PAINTOR_V3.0/PAINTOR_Utilities/CalcLD_1KG_VCF.py"
# specify AnnotateLocus.py from PAINTOR
annotation_matrix_cal="/f/mulinlab/huan/tools/PAINTOR_V3.0/PAINTOR_Utilities/AnnotateLocus.py"
# specify bgzip from htslib
bgzip="/f/Tools/htslib/htslib-1.5/bgzip"
# specify tabix from htslib
tabix="/f/Tools/htslib/htslib-1.5/tabix"
# specify paintor
paintor="/f/mulinlab/huan/tools/PAINTOR_V3.0/PAINTOR"

# references
# =================================================================================
# the LD_block file should match the ethnicity of the GWAS population
# downloaded from https://bitbucket.org/nygcresearch/ldetect-data/src
LD_block="/f/mulinlab/huan/summary_statistics/fine_mapping/causal_tissue/pikrell_independent_LD_block/nygcresearch-ldetect-data-ac125e47bf7f/ASN/fourier_ls-all.bed"
# usually 1000 genome reference file are splitted into chromosomes, and CalcLD_1KG_VCF.py 
# need to specify reference with matched chromosome so the 1000 genome reference variable was 
# splitted into two parts
reference_1000G_front="/g/mulin/1000g/ALL.chr"
reference_1000G_back=".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
# spcify the 1000 genome panel file
reference_1000G_panel="/g/hongcheng/causal_tissue/1000g/integrated_call_samples_v3.20130502.ALL.panel"


# pipeline section
# =================================================================================
# =================================================================================

# file splitting into loci according to pikrell independent LD block 
# =================================================================================

# use bgzip to compress the file, use tabix to build the index file
${bgzip} ${folder_address}${file_name}
${tabix} -s 1 -b 2 -e 2 -S 1 ${folder_address}${file_name}.gz

# make two directories for splitted loci and filtered loci
mkdir ${gwas_loci_dir}
mkdir ${gwas_filtered_loci_dir}

# split the file into loci and put them in the gwas_loci_dir
OLD_IFS="$IFS" 
IFS=$'\t'
cat ${LD_block} | while read line
do
	array=(${line})
	chrnum=${array[0]#*chr}
	chrnum=${chrnum// /}
	start=${array[1]// /}
	end=${array[2]// /}
	if [ "${start}" != "start" ]; then
	# use tabix to extract the region and transform it to space delimited format for paintor
	tabix ${file_addre}${file_name}.gz ${chrnum}:${start}-${end} | sed '1i chr pos rsid effect_allele baseline_allele effect_size se Pvalue Zscore' | \
	sed 's/\t/ /g' > ${gwas_loci_dir}${file_name}.paintorformat.${chrnum}_${start}_${end}
	fi
done
IFS="$OLD_IFS"

# loci filtering according to P value
# =================================================================================
cd ${gwas_loci_dir}
:> gwas_filtered_loci
for file in $(ls -tr ${file_name}*)
do
	awk -v pvalue=${pvalue_threshold} 'BEGIN{FS=OFS=" ";n=0}{if($8 <= pvalue){n+=1}} END{if(n>0){print FILENAME}}' ${file} >> gwas_filtered_loci
done

# copy the filtered gwas loci to gwas_filtered_loci_dir
cd ${gwas_loci_dir}
cp $(cat gwas_filtered_loci) ${gwas_filtered_loci_dir}


# LD matrix generation
# =================================================================================
# use the CalcLD_1KG_VCF.py script to calculate the LD matrix, it will output two files
# one for matching SNP found in the reference panel(others are discarded), the other one is
# the LD matrix of the remaining SNP, use these two files as the input for following process

cd ${gwas_filtered_loci_dir}

for subfile in $(ls)
do
subfile_chr=$(expr match ${subfile} '.*paintorformat\.\([0-9]*\)_.*_.*')

python ${LD_matrix_cal} \
--locus ${subfile} \
--reference ${reference_1000G_front}${subfile_chr}${reference_1000G_back} \
--map ${reference_1000G_panel} \
--effect_allele effect_allele \
--alt_allele baseline_allele \
--population ${ethnicity} \
--Zhead Zscore \
--out_name ${subfile} \
--position pos 
done

for i in $(ls *ld)
do
mv ${i} ${i%.ld}.processed.ld
done

# Annotation matrix generation
# =================================================================================

for processed_file in $(ls *processed)
do
python ${annotation_matrix_cal} \
--input ${annotation_paths_list} \
--locus ${processed_file} \
--out ${processed_file}.annotations \
--chr chr \
--pos pos
done

# finally, for running paintor, see following website
# https://github.com/gkichaev/PAINTOR_V3.0/wiki/3.-Running-Software-and-Suggested-Pipeline

