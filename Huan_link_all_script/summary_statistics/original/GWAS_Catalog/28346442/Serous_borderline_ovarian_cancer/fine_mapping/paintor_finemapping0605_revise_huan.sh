# This is the file for automatic finemapping preparation for PAINTOR v3.1
# =================================================================================
# =================================================================================


# input variables
# =================================================================================
# the input file must be tab delimited
# its columns must be: chr pos rsid effect_allele baseline_allele effect_size se Pvalue Zscore
# make a new directory for finemapping and put the gwas file inside

# the file name
file_name="28346442_Serous_borderline_ovarian_cancer_normalized_sorted.txt"
#file_name="Z85.assoc.normalized_sorted.txt"
# the folder address
folder_address="/f/mulinlab/huan/summary_statistics/original/GWAS_Catalog/28346442/Serous_borderline_ovarian_cancer/fine_mapping/paintor/"
#folder_address="/f/mulinlab/huan/summary_statistics/original/UKBB_biobank/fine_mapping/paintor/Z85/"
# the annotation file list, put the annotations' file addresses in it
annotation_paths_list="/f/mulinlab/huan/summary_statistics/fine_mapping/anno/anno_path/overvall_cancer_annotation_paths"
# specify name of continental population {AFR, AMR, EAS, EUR, SAS} to compute LD by CalcLD_1KG_VCF.py
ethnicity="EUR"

# pvalue threshold used to filter loci, e.g., 5e-8 means only loci with at least one SNP whose
# P value < 5e-8 will be kept
pvalue_threshold=5e-8

# variables generated based on input variables
gwas_loci_dir=${folder_address}split_loci/
gwas_filtered_loci_dir=${folder_address}filtered_loci/

# references
# =================================================================================
# the LD_block file should match the ethnicity of the GWAS population
# downloaded from https://bitbucket.org/nygcresearch/ldetect-data/src
LD_block="/f/mulinlab/huan/summary_statistics/fine_mapping/causal_tissue/pikrell_independent_LD_block/nygcresearch-ldetect-data-ac125e47bf7f/EUR/fourier_ls-all.bed"
# usually 1000 genome reference file are splitted into chromosomes, and CalcLD_1KG_VCF.py 
# need to specify reference with matched chromosome so the 1000 genome reference variable was 
# splitted into two parts
reference_1000G_front="/f/mulinlab/huan/summary_statistics/fine_mapping/mulin_1000g/1000g/ALL.chr"
reference_1000G_back=".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
# spcify the 1000 genome panel file
reference_1000G_panel="/f/mulinlab/huan/summary_statistics/fine_mapping/hongcheng/causal_tissue/1000g/integrated_call_samples_v3.20130502.ALL.panel"

# tools
# =================================================================================
# PAINTOR can be downloaded from https://github.com/gkichaev/PAINTOR_V3.0
# htslib can be downloaded from http://www.htslib.org/download/

# specify CalcLD_1KG_VCF.py from PAINTOR
LD_matrix_cal="/f/mulinlab/huan/tools/PAINTOR_V3.0/PAINTOR_Utilities/CalcLD_1KG_VCF.py"
# specify AnnotateLocus.py from PAINTOR
annotation_matrix_cal="/f/mulinlab/huan/tools/PAINTOR_V3.0/PAINTOR_Utilities/AnnotateLocus.py"
# specify bgzip from htslib
bgzip="/f/Tools/htslib/htslib-1.3.2/bgzip"
# specify tabix from htslib
tabix="/f/Tools/htslib/htslib-1.5/tabix"
# specify paintor
paintor="/f/mulinlab/huan/tools/PAINTOR_V3.0/PAINTOR"

# gwas file parameters
# =================================================================================
chr_name="chromosome"
pos_name="position"
eallele_name="effect_allele"
ballele_name="baseline_allele"
zscore_name="Zscore"
pvalue_name="OR_P"


help="PAINTOR Finemapping Preparation pipeline
A simple script for automatic finemapping preparation for PAINTOR v3.1,
the input file should be tab delimited

GWAS File Parameter
-c    specify chr column name                                     <default: ${chr_name}>
-p    specify pos column name                                     <default: ${pos_name}>
-e    specify effective_allele column name                        <default: ${eallele_name}>
-b    specify baseline_allele column name                         <default: ${ballele_name}>
-z    specify Zscore column name                                  <default: ${zscore_name}>
-P    specify P value column name                                 <default: ${pvalue_name}>

GWAS File Information
-f    specify the GWAS file name                                  <default: ${file_name}>
NOTE: since this script use tabix to split the GWAS file, the GWAS file must be sorted
-F    specify the folder address                                  <default: ${folder_address}>
NOTE: make sure the folder address ends with /        
-a    specify the annotation list file                            <default: ${annotation_paths_list}>
-o    specify name of continental population                      <default: ${ethnicity}>
      {AFR, AMR, EAS, EUR, SAS} to compute LD by CalcLD_1KG_VCF.py
-t    specify the p value threshold                               <default: ${pvalue_threshold}>

Reference Files
-1    specify the LD block file                                   <default: ${LD_block}>
NOTE: the LD block file is population specific, and you should specify matched LD block file with 
your gwas file
-2    specify the front 1000g reference file                      <default: ${reference_1000G_front}>
-3    specify the back 1000g reference file                       <default: ${reference_1000G_back}>
usually 1000 genome reference file are splitted into chromosomes, and CalcLD_1KG_VCF.py 
need to specify reference with matched chromosome so the 1000 genome reference variable 
was splitted into two parts
-4    specify 1000g panel file                                    <default: ${reference_1000G_panel}>

Tools
-5    specify the CalcLD_1KG_VCF.py from PAINTOR                  <default: ${LD_matrix_cal}>
-6    specify AnnotateLocus.py from PAINTOR                       <default: ${annotation_matrix_cal}>
-7    specify bgzip from htslib                                   <default: ${bgzip}>
-8    specify tabix from htslib                                   <default: ${tabix}>
"

while getopts ":c:p:e:b:z:P:f:F:a:o:t:1:2:3:4:5:6:7:8:h" opt; do
	case $opt in
		c)
			chr_name=$OPTARG
			;;
		p)
			pos_name=$OPTARG
			;;
		e)
			eallele_name=$OPTARG
			;;
		b)
			ballele_name=$OPTARG
			;;
		z)
			zscore_name=$OPTARG
			;;
		P)
			pvalue_name=$OPTARG
			;;
		f)
			file_name=$OPTARG
			;;
		F)
			folder_address=$OPTARG
			;;
		a)
			annotation_paths_list=$OPTARG
			;;
		o)
			ethnicity=$OPTARG
			;;
		t)
			pvalue_threshold=$OPTARG
			;;
		1)
			LD_block=$OPTARG
			;;
		2)
			reference_1000G_front=$OPTARG
			;;
		3)
			reference_1000G_back=$OPTARG
			;;
		4)
			reference_1000G_panel=$OPTARG
			;;
		5)
			LD_matrix_cal=$OPTARG
			;;
		6)
			annotation_matrix_cal=$OPTARG
			;;
		7)
			bgzip=$OPTARG
			;;
		8)
			tabix=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			exit 1
			;;
		h)
			printf '%s\n' "$help"
			exit 0
			;;
	esac
done

shift $((OPTIND-1))



checkError="0";
if [ -z "$chr_name" ]
then
	echo "Please specify the chr column name"
	checkError="1"
fi
if [ -z "$pos_name" ]
then
	echo "Please specify the pos column name"
	checkError="1"
fi
if [ -z "$eallele_name" ]
then
	echo "Please specify effective_allele column name"
	checkError="1"
fi
if [ -z "$ballele_name" ]
then
	echo "Please specify baseline_allele column name"
	checkError="1"
fi
if [ -z "$zscore_name" ]
then
	echo "Please specify Zscore column name"
	checkError="1"
fi
if [ -z "$pvalue_name" ]
then
	echo "Please specify P value column name"
	checkError="1"
fi

if [ -z "$file_name" ]
then
	echo "Please specify the gwas file name"
	checkError="1"
fi
if [ -z "$folder_address" ]
then
	echo "Please specify the folder address"
	checkError="1"
fi
if [ -z "$annotation_paths_list" ]
then
	echo "Please specify the annotation list file"
	checkError="1"
fi
if [ -z "$ethnicity" ]
then
	echo "Please specify name of continental population"
	checkError="1"
fi

if [ "$checkError" -eq "1" ]
then 
	echo "======================================="

	printf '%s\n' "$help"
	exit -1
fi



# resepcify these two variables
gwas_loci_dir=${folder_address}split_loci/
gwas_filtered_loci_dir=${folder_address}filtered_loci/


chr_ind=
pos_ind=
eallele_ind=
ballele_ind=
zscore_ind=
pvalue_ind=

chr_ind=$(awk -v par=${chr_name} 'BEGIN{FS=OFS=" "}
NR==1{for(i=1;i<=NF;i++){if($i==par){print i;exit} } }' ${folder_address}${file_name})
pos_ind=$(awk -v par=${pos_name} 'BEGIN{FS=OFS=" "}
NR==1{for(i=1;i<=NF;i++){if($i==par){print i;exit} } }' ${folder_address}${file_name})
eallele_ind=$(awk -v par=${eallele_name} 'BEGIN{FS=OFS=" "}
NR==1{for(i=1;i<=NF;i++){if($i==par){print i;exit} } }' ${folder_address}${file_name})
ballele_ind=$(awk -v par=${ballele_name} 'BEGIN{FS=OFS=" "}
NR==1{for(i=1;i<=NF;i++){if($i==par){print i;exit} } }' ${folder_address}${file_name})
zscore_ind=$(awk -v par=${zscore_name} 'BEGIN{FS=OFS=" "}
NR==1{for(i=1;i<=NF;i++){if($i==par){print i;exit} } }' ${folder_address}${file_name})
pvalue_ind=$(awk -v par=${pvalue_name} 'BEGIN{FS=OFS=" "}
NR==1{for(i=1;i<=NF;i++){if($i==par){print i;exit} } }' ${folder_address}${file_name})


# file splitting into loci according to pikrell independent LD block 
# =================================================================================

header=$(head -n 1 ${folder_address}${file_name})

# move to the working directory
cd ${folder_address}

# use bgzip to compress the file, use tabix to build the index file
${bgzip} ${folder_address}${file_name}
${tabix} -s ${chr_ind} -b ${pos_ind} -e ${pos_ind} -S 1 ${folder_address}${file_name}.gz

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
	tabix ${file_addre}${file_name}.gz ${chrnum}:${start}-${end} | sed "1i $header" | \
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
	awk -v pvalue=${pvalue_threshold} -v ind=${pvalue_ind} 'BEGIN{FS=OFS=" ";n=0}NR!=1{if($ind <= pvalue){n+=1}} END{if(n>0){print FILENAME}}' ${file} >> gwas_filtered_loci
done


if [ ! -s gwas_filtered_loci ]
then
	echo "====================================="
	echo "No loci satisfy the P value threshold"
	exit 0
fi




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
--effect_allele ${eallele_name} \
--alt_allele ${ballele_name} \
--population ${ethnicity} \
--Zhead ${zscore_name} \
--out_name ${subfile} \
--position ${pos_name} 
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
--chr ${chr_name} \
--pos ${pos_name}
done

# finally, for running paintor, see following website
# https://github.com/gkichaev/PAINTOR_V3.0/wiki/3.-Running-Software-and-Suggested-Pipeline

