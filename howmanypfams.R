# Calculating the number of Pfams with greater than or equal to a given
# number of sequences. This script is deprecated; use the pfam summary script
# instead. The calculate percent gaps function at the end might be worth
# salvaging, however.

# Setting the working directory.
setwd("~/not_backed_up/alignments")

# Import libraries.
library(stringr)
library(dplyr)

# Load image.
load("~/bin/Scripts/RScripts/howmanypfams.RData")

# Save image.
save.image("~/bin/Scripts/RScripts/howmanypfams.RData")

# Loading the alignmet data.
align.data <- read.table("Pfam_alignments_all.tsv", header = T,
                         sep = "\t")

# Count Pfams with greater than or equal X sequences.
length(unique(align.data[,2]))
length(align.data[,1])
11086587/10429
pfam.seq.counts <- table(align.data[,2])
length(pfam.seq.counts)
length(pfam.seq.counts[pfam.seq.counts <= 100 & pfam.seq.counts > 2])

# Function for generating FASTA files.
# Currently, the column name for the Pfam ID must be titled "PfamUID",
# the species column must be titled "NewickSpeciesName", and
# the alignment column must be titled "AlignedPeptide".
generate.fasta <- function(pfam.id, pfam.alignments){
  full.fasta <- ""
  df.subset <- pfam.alignments[pfam.alignments$PfamUID == pfam.id, ]
  df.length <- length(df.subset[, 2])
  current.fasta <- ""
  for (i in 1:df.length) {
    current.fasta <- paste(">", df.subset$NewickSpeciesName[i], "|", df.subset$UID[i], "-", df.subset$PfamUID[i],
                           "\n", df.subset$AlignedPeptide[i], "\n", sep = "")
    full.fasta <- paste(full.fasta, current.fasta, sep = "")
  }
  return(full.fasta)
}

pfam.seq.counts[pfam.seq.counts == 500]
PF05292.fasta <- generate.fasta("PF05292", align.data)
write(PF05292.fasta, file = "PF05292.fasta")

pfam.seq.counts[pfam.seq.counts == 400]
PF02274.fasta <- generate.fasta("PF02274", align.data)
write(PF02274.fasta, file = "PF02274.fasta")

pfam.seq.counts[pfam.seq.counts == 300]
PF01029.fasta <- generate.fasta("PF01029", align.data)
write(PF01029.fasta, file = "PF01029.fasta")

pfam.seq.counts[pfam.seq.counts == 200]
PF00283.fasta <- generate.fasta("PF00283", align.data)
write(PF00283.fasta, file = "PF00283.fasta")

pfam.seq.counts[pfam.seq.counts == 100]
PF06109.fasta <- generate.fasta("PF06109", align.data)
write(PF06109.fasta, file = "PF06109.fasta")

pfam.seq.counts[pfam.seq.counts == 600]
PF03615.fasta <- generate.fasta("PF03615", align.data)
write(PF03615.fasta, file = "PF03615.fasta")

pfam.seq.counts[pfam.seq.counts == 700]
PF02823.fasta <- generate.fasta("PF02823", align.data)
write(PF02823.fasta, file = "PF02823.fasta")

pfam.seq.counts[pfam.seq.counts == 900]
PF00833.fasta <- generate.fasta("PF00833", align.data)
write(PF00833.fasta, file = "PF00833.fasta")

# Calculate percent gaps in an alignment.
percent.gaps <- function(dataset,
                         pfamid,
                         pfamid.col = "PfamUID",
                         alignment.col = "AlignedPeptide"){
  alignment.vector <- dataset[dataset[, pfamid.col] == pfamid, alignment.col]
  sequences <- length(alignment.vector)
  gaps = 0
  sites = 0
  for (i in 1:sequences) {
    sites = sites + str_length(alignment.vector[i])
    gaps = gaps + str_count(alignment.vector[i], pattern = "-")
  }
  #print(sites)
  #print(gaps)
  #print(sequences)
  sites.per.pfam <- sites / sequences
  return(c(gaps / sites, sites.per.pfam))
}
