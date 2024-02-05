# !/bin/bash

#--------------
###alignment
#--------------

    # cd /mnt/e/Mahdi/Nanopore/Validation/External
    # gatk MarkDuplicates \
    #     I=HG002_sorted.bam \
    #     O=HG002_Sorted_RMDup.bam \
    #     REMOVE_DUPLICATES=true \
    #     M=HG002_Removed_dup_metrics.txt

#---------------
### VCF_Filtering
#---------------



# for i in {1..5}; do
#  cd /mnt/e/Mahdi/Nanopore/BQSR/B${i}
#  bgzip -c B${i}_DeepVar_BQSR.vcf > B${i}_DeepVar_BQSR.vcf.gz
#  tabix -p vcf B${i}_DeepVar_BQSR.vcf.gz
#  bcftools view -i 'FORMAT/DP > 10 & QUAL > 10' -r chr13:32889645-32974405,chr17:41196312-41277381 -f PASS B${i}_DeepVar_BQSR.vcf.gz > B${i}_DeepVar_BQSR_Filtered.vcf
#  bgzip -c B${i}_DeepVar_BQSR_Filtered.vcf > B${i}_DeepVar_BQSR_Filtered.vcf.gz
#  sudo gunzip B${i}_DeepVar_BQSR_Filtered.vcf.gz
# done
#  tabix -p vcf B6_Truth.vcf.gz
#  sudo gunzip B6_Truth.vcf.gz
# done

## MEDAKA Filtering
# cd /mnt/e/Mahdi/Nanopore/B6/Comparison
# bgzip -c Pipe4.vcf > Pipe4.vcf.gz
# tabix -p vcf Pipe4.vcf.gz
# bcftools view -i 'QUAL > 10' -r chr13:32889645-32974405,chr17:41196312-41277381 -f PASS Pipe4.vcf.gz > Pipe4.vcf
# bgzip -c Pipe4.vcf > Pipe4.vcf.gz
# tabix -p vcf Pipe4.vcf.gz
# sudo gunzip Pipe4.vcf.gz


#---------------
### VCF_Comparison
#---------------

# for i in {10..11}; do
#  sudo docker run -it -v /mnt/e/Mahdi/Nanopore/B1/Comparison:/data f69ea1624f20 /opt/hap.py/bin/hap.py -r /data/hg19.fa /data/B1_TruthVariants_DP50.vcf \
#   /data/Pipe${i}.vcf -o /data/Pipe${i}/comparison_output
# done

# for i in {5..10}; do
#  sudo docker run -it -v /mnt/e/Mahdi/Nanopore/B6/Comparison:/data f69ea1624f20 /opt/hap.py/bin/hap.py -r /data/hg19.fa /data/B6_TruthVariantsDP50.vcf \
#   /data/Pipe${i}.vcf -o /data/Pipe${i}/comparison_output
# done

#----------------
### Clair3
#----------------

# for i in {15..17}; do
#   cd /mnt/e/Mahdi/Nanopore/Validation/External
#   INPUT_DIR="/mnt/e/Mahdi/Nanopore/Validation/External"
#   OUTPUT_DIR="/mnt/e/Mahdi/Nanopore/Validation/External"
#   THREADS="24"
#   MODEL_NAME="r941_prom_sup_g5014"

#   docker run -it \
#     -v "${INPUT_DIR}:${INPUT_DIR}" \
#     -v "${OUTPUT_DIR}:${OUTPUT_DIR}" \
#     hkubal/clair3:latest \
#     /opt/bin/run_clair3.sh \
#     --bam_fn="${INPUT_DIR}/HG002_Sorted.bam" \
#     --ref_fn="${INPUT_DIR}/hg19.fa" \
#     --threads="${THREADS}" \
#     --platform="ont" \
#     --model_path="/opt/models/${MODEL_NAME}" \
#     --output="${OUTPUT_DIR}" \
#  #  --bed_fn="${INPUT_DIR}/BRCA1_BRCA2.bed
#   cd ..
# done


#--------------
### NanoCaller
#--------------
# for i in {6..7}; do

#  INPUT_DIR="/mnt/e/Mahdi/Nanopore/B${i}"
#  OUTPUT_DIR="/mnt/e/Mahdi/Nanopore/B${i}/Pipe10"
#  VERSION="3.4.1"

#  docker run \
#  -v ${INPUT_DIR}:'/input/' \
#  -v ${OUTPUT_DIR}:'/output/' \
#  genomicslab/nanocaller:${VERSION} \
#  NanoCaller \
#  --bam /input/B${i}_sorted_RemDup.bam \
#  --ref /input/hg19.fa \
#  --output /output \
#  --cpu 24
#  --preset PRESET
# done


#-----------------
###MEDAKA
#-----------------

# for i in {2..6}; do 
#  cd /mnt/e/Mahdi/Nanopore/B${i}/Pipe4
#  NPROC=24
#   BASECALLS="/mnt/e/Mahdi/Nanopore/B${i}/B${i}.fastq"
#   CONSENSUS= "/mnt/e/Mahdi/Nanopore/B${i}/Pipe4/consensus_probs.hdf"
#    DRAFT="/home/bongs/NGS/RefGenome/hg19.fa"
#   OUTDIR="/mnt/e/Mahdi/Nanopore/B${i}/Pipe4"

#   medaka_consensus -i ${BASECALLS} -d ${DRAFT} -o ${OUTDIR} -t ${NPROC} -m r1041_e82_400bps_sup_v4.2.0
#  medaka variant /home/bongs/NGS/RefGenome/hg19.fa consensus_probs.hdf B${i}_MEDAKA.vcf --regions chr13 chr17
#  cd ../..
# done

#-----------------------
### DeepVariant
#-----------------------


# for i in {1..6}; do
#   cd /mnt/e/Mahdi/Nanopore/B${i}
#   docker run -it --rm --gpus all \
#     -v /mnt/e/Mahdi/Nanopore/B${i}:/input \
#     -v /mnt/e/Mahdi/Nanopore/BQSR/B${i}:/output \
#     -v /home/bongs/NGS/RefGenome:/reference \
#     gcr.io/deepvariant-docker/deepvariant \
#     /opt/deepvariant/bin/run_deepvariant \
#     --model_type=ONT_R104 \
#     --ref=/reference/hg19.fa \
#     --reads=/input/"B${i}_sorted_BQSR.bam" \
#     --output_vcf=/output/"B${i}_DeepVar_BQSR.vcf" \
#     --output_gvcf=/output/"B${i}_DeepVar_BQSR.gvcf" \
#     --num_shards=$(nproc) \
#     --logging_dir=/output/"B${i}_DeepVar_BQSR_log" 

# done






#---------------------
### Kishwar/PEPPER deepvariant
#---------------------

# for i in {1..6}; do 

#  BASE="${HOME}/gpu-quickstart"

#  # Set up input data
#  INPUT_DIR="${BASE}/input/data"
#  REF="GRCh38_no_alt.chr20.fa"
#  BAM="HG002_ONT_2_GRCh38.chr20.quickstart.bam"

#  # Set the number of CPUs to use
#  THREADS="1"

#  # Set up output directory
#  OUTPUT_DIR="${BASE}/output"
#  OUTPUT_PREFIX="HG002_ONT_2_GRCh38_PEPPER_Margin_DeepVariant.chr20"
#  OUTPUT_VCF="HG002_ONT_2_GRCh38_PEPPER_Margin_DeepVariant.chr20.vcf.gz"
#  TRUTH_VCF="HG002_GRCh38_1_22_v4.2.1_benchmark.quickstart.vcf.gz"
#  TRUTH_BED="HG002_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.quickstart.bed"

#  sudo docker run --ipc=host \
#  -v "${INPUT_DIR}":"${INPUT_DIR}" \
#  -v "${OUTPUT_DIR}":"${OUTPUT_DIR}" \
#  --gpus all \
#  kishwars/pepper_deepvariant:r0.7-gpu \
#  run_pepper_margin_deepvariant call_variant \
#  -b "${INPUT_DIR}/${BAM}" \
#  -f "${INPUT_DIR}/${REF}" \
#  -o "${OUTPUT_DIR}" \
#  -p "${OUTPUT_PREFIX}" \
#  -t ${THREADS} \
#  -r chr20:1000000-1020000 \
#  -g \
#  --ont_r10_q20

# done

#-----------------------------

# for i in {15..17}; do

#  dir="/mnt/e/Mahdi/Nanopore/Tajrish/B1${i}"
#  INPUT_DIR="/mnt/e/Mahdi/Nanopore/Tajrish/B1${i}"
#  REF="/home/bongs/NGS/RefGenome"
#  BAM="B1${i}_sorted.bam"
#  OUTPUT_DIR="/mnt/e/Mahdi/Nanopore/Tajrish/B1${i}"
#  OUTPUT_PREFIX="B1${i}"
#  OUTPUT_VCF="B1${i}.vcf.gz"
#  THREADS="24"

#  cd "$dir"

#  docker run \
#   -v "${INPUT_DIR}":"${INPUT_DIR}" \
#   -v "${OUTPUT_DIR}":"${OUTPUT_DIR}" \
#   -v "${REF}":"${REF}" \
#   kishwars/pepper_deepvariant:r0.7-gpu \
#   run_pepper_margin_deepvariant call_variant \
#   -b "${INPUT_DIR}/${BAM}" \
#   -f "${REF}/hg19.fa" \
#   -o "${OUTPUT_DIR}" \
#   -p "${OUTPUT_PREFIX}" \
#   -t ${THREADS} \
#   --ont_r10_q20

#   cd ..

# done


# dir="/mnt/e/Mahdi/Nanopore/B5"
# INPUT_DIR="/mnt/e/Mahdi/Nanopore/B5"
# REF="/home/bongs/NGS/RefGenome"
# BAM="B5_sorted_BQSR.bam"
# OUTPUT_DIR="/mnt/e/Mahdi/Nanopore/B5/BQSR/Pipe8"
# OUTPUT_PREFIX="B5"
# OUTPUT_VCF="B5_BQSR.vcf.gz"
# THREADS="24"

# cd "$dir"

# docker run \
#   -v "${INPUT_DIR}":"${INPUT_DIR}" \
#   -v "${OUTPUT_DIR}":"${OUTPUT_DIR}" \
#   -v "${REF}":"${REF}" \
#   kishwars/pepper_deepvariant:r0.7-gpu \
#   run_pepper_margin_deepvariant call_variant \
#   -b "${INPUT_DIR}/${BAM}" \
#   -f "${REF}/hg19.fa" \
#   -o "${OUTPUT_DIR}" \
#   -p "${OUTPUT_PREFIX}" \
#   -t ${THREADS} \
#   --ont_r10_q20

# cd ..

#-------------------
### Variant Effect Predictor
#-------------------




#-------------
### hap.py for BQSR
#-------------

# for i in {1..5}; do
#  sudo docker run -it -v /mnt/e/Mahdi/Nanopore/Validation:/data f69ea1624f20 /opt/hap.py/bin/hap.py -r /data/hg19.fa /data/B6_TruthVariantsDP50.vcf \
#   /data/Pipe1.vcf -o /data/Pipe1/comparison_output
# done

#----------------
### MarkDup
#---------------
#   cd ~
#   java -jar picard.jar MarkDuplicates \
#         I=/mnt/e/Mahdi/Nanopore/Epi2meLabs_GIAB/hg002/cat_sorted.bam \
#         O=/mnt/e/Mahdi/Nanopore/Epi2meLabs_GIAB/hg002/cat_sorted_RMDUP.bam \
#         REMOVE_DUPLICATES=true \
#         M=/mnt/e/Mahdi/Nanopore/Epi2meLabs_GIAB/hg002/Metrics.txt


#   cd /mnt/e/Mahdi/Nanopore/Epi2meLabs_GIAB/hg002/
#   docker run -it --rm --gpus all \
#     -v /mnt/e/Mahdi/Nanopore/Epi2meLabs_GIAB/hg002/:/input \
#     -v /mnt/e/Mahdi/Nanopore/Epi2meLabs_GIAB/hg002/:/output \
#     -v /home/bongs/NGS/RefGenome:/reference \
#     gcr.io/deepvariant-docker/deepvariant \
#     /opt/deepvariant/bin/run_deepvariant \
#     --model_type=ONT_R104 \
#     --ref=/reference/hg19.fa \
#     --reads=/input/"cat_sorted.bam" \
#     --output_vcf=/output/"cat.vcf" \
#     --output_gvcf=/output/"cat.gvcf" \
#     --num_shards=24 \
#     --logging_dir=/output/"cat_log" 

#--------------------
### ANNOVAR
#--------------------
    # cd /home/bongs/annovar
    # ./convert2annovar.pl -format vcf4 /mnt/e/Mahdi/Nanopore/Validation/Pipe15.vcf > /mnt/e/Mahdi/Nanopore/Validation/Pipe15.avinput
    # ./annotate_variation.pl -buildver hg19 /mnt/e/Mahdi/Nanopore/Validation/Pipe15.avinput humandb/


    ###Validation
    # cd /mnt/e/Mahdi/Nanopore/Validation/External/HG002_Sorted.bam
    # docker run -it --rm --gpus all \
    # -v /mnt/e/Mahdi/Nanopore/Validation/External:/input \
    # -v /mnt/e/Mahdi/Nanopore/Validation/External:/output \
    # -v /home/bongs/NGS/RefGenome:/reference \
    # gcr.io/deepvariant-docker/deepvariant \
    # /opt/deepvariant/bin/run_deepvariant \
    # --model_type=ONT_R104 \
    # --ref=/reference/hg19.fa \
    # --reads=/input/HG002_Sorted_RMDup.bam \
    # --output_vcf=/output/HG002_DeepVar.vcf \
    # --output_gvcf=/output/HG002_DeepVar.gvcf \
    # --num_shards=$(nproc) \
    # --logging_dir=/output/HG002_DeepVar_log
