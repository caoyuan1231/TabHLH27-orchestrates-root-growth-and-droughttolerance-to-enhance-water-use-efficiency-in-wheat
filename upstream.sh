fastp -i ./rawgz/samplename_1.fq.gz -I ./rawgz/samplename_2.fq.gz -o ./clean/samplename.R1.clean.fq.gz -O ./clean/samplename.R2.clean.fq.gz --detect_adapter_for_pe -w 8 --compression 9 -c -l 50 &&
echo ">>>fastp done"
hisat2 -x ./hisat.index/CS -p 8 -5 10 --min-intronlen 20 --max-intronlen 4000 -1 ./clean/samplename.R1.clean.fq.gz -2 ./clean/samplename.R2.clean.fq.gz 2> ./hisat2/samplename.hisat2.log | samtools view -bS -q 20 -@ 8 | samtools sort - -o ./hisat2/samplename.sorted.bam &&
echo ">>>hisat2 done"
featureCounts -T 16 -t exon -p -P -B -C -g gene_id -a ~/data/cs/wheat.gtf -o feacount.txt ./hisat2/samplename.sorted.bam
