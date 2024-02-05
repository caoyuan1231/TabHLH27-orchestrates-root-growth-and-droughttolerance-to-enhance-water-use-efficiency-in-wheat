fimo --o bhlhtarget bHLHmotif.meme atac.peak.fa # atac.peak.fa contains sequences of promoter open region of up/down rregulated genes
cd bhlhtarget
awk '{print$3}' fimo.tsv | sort | uniq  > bHLHtar.txt    #get bHLH27 direct target genes
seqkit grep -f bHLHtar.txt ../all.promoter.atac.fa > bHLHtar.fa   #get bHLH27 direct target genes promoter open sequences
sea --p bHLHtar.fa --m Ath_TF_binding_motifs.meme --n ../50000.promoter.atac.fa # 50000.promoter.atac.fa contains randomly selected 50000 sequences from all promoter open region