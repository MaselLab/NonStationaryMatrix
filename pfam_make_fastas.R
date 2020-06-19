# Make FASTA files from alignments.

# Setting the working directory.
# setwd("~/not_backed_up/alignments")

# Import libraries.
library(stringr)
# library(plyr)

# Load image. This image should contain the alignment summaries used to subset the data.
load("/extra/ljkosinski/Scripts/RateShift/pfam_summary_9-13-19.RData")

# Variables for subsetting the data.
pfam.seqs.max <- 300 # This is a less than or equal to.
pfam.seqs.min <- 200 # This is greater than.
#pfam.sites <- 100

# Should the output be in FASTA or Phylip format?
# I am not sure I have the Phylip format output working properly.
phylip.format <- FALSE

# Pfam directory
pfam.dir <- "/extra/ljkosinski/Alignments/Pfam300/"

# Function for generating FASTA files.
# Currently, the column name for the Pfam ID must be titled "PfamUID",
# the species column must be titled "NewickSpeciesName", and
# the alignment column must be titled "AlignedPeptide".
# Can also be set to generate Phylip files instead.
generate.fasta <- function(pfam.id, pfam.alignments, phylip = FALSE){
  full.seq <- ""
  df.subset <- pfam.alignments[pfam.alignments$PfamUID == pfam.id, ]
  df.length <- length(df.subset[, 2])
  current.seq <- ""
  if (phylip == FALSE){
    for (i in 1:df.length) {
      current.seq <- paste(">", df.subset$NewickSpeciesName[i], "|", df.subset$UID[i], "-", df.subset$PfamUID[i],
                             "\n", df.subset$AlignedPeptide[i], "\n", sep = "")
      full.seq <- paste(full.seq, current.seq, sep = "")
    }
  } else if (phylip == TRUE){
      header <- paste(df.length, " ", str_length(df.subset$AlignedPeptide[1]), "\n", sep = "")
      full.seq <- paste(full.seq, header, sep = "")
      for (i in 1:df.length) {
        current.seq <- paste(df.subset$NewickSpeciesName[i], "|", df.subset$UID[i], "-", df.subset$PfamUID[i], "\t", df.subset$AlignedPeptide[i], "\n", sep = "")
        full.seq <- paste(full.seq, current.seq, sep = "")
    }
  } else {
      print("Format not set properly!")
  }
  return(full.seq)
}

# Outputting FASTA files based on the appropriate sites/seqs parameters.
pfam.subset <- pfam.summary[
  pfam.summary$Sequences <= pfam.seqs.max
  & pfam.summary$Sequences > pfam.seqs.min
  #& pfam.summary$Sites <= pfam.sites
  , ]
#print(length(pfam.subset$PfamUID))
current.pfam <- ""
current.alignment <- ""
for (i in 1:length(pfam.subset$PfamUID)) {
  if (phylip.format == FALSE){
    file.type <- ".fasta"
  } else {
    file.type <- ".phylip"
  }
  current.pfam <- paste(pfam.dir, pfam.subset$PfamUID[i], file.type, sep = "")
  print(current.pfam)
  current.alignment <- generate.fasta(pfam.subset$PfamUID[i], align.data, phylip.format)
  write(current.alignment, file = current.pfam)
  current.pfam <- ""
  current.alignment <- ""
}
