# Randomly sample Pfams and output as FASTA format. This script was used initially
# to test RAxML run times.

# Load required libraries.
library(stringr)

# Load image.
load("/extra/ljkosinski/Scripts/RateShift/runtime_pfams.RData")

# Global variables.
sample.size <- 20 # How many Pfams to randomly sample.
pfam.dir <- "/extra/ljkosinski/Alignments/PfamSample/" # The director where the FASTA files will be written.
phylip.format <- FALSE

# Function for generating FASTA files.
# Currently, the column name for the Pfam ID must be titled "PfamUID",
# the species column must be titled "NewickSpeciesName", and
# the alignment column must be titled "AlignedPeptide".
# Can also be set to generate Phylip files instead (NOT WORKING CURRENTLY).
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

# Randomply sample Pfams.
pfam.sample <- sample(unique(align.data$PfamUID), sample.size)

# Output sampled Pfams as FASTA files.
pfam.subset <- pfam.summary[pfam.summary$PfamUID %in% pfam.sample, ]
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
