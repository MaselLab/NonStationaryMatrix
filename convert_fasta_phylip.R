# Convert FASTA to Phylip format.

library(phylotools)
# library(stringr)

# Global variables.
path.to.directory <- "/extra/ljkosinski/Alignments/Pfam100/"
output.directory <- "/extra/ljkosinski/Alignments/Pfam100/Phylip/"

# Convert FASTA files in directory to Phylip.
# First, get all ".fasta" files in a directory.
# NB: Only grabs files that END with ".fasta".
directory.files <- list.files(path.to.directory)
fasta.files <- directory.files[grep("*.fasta$", directory.files)]
fasta.files

# Convert FASTA files to Phylip.
output.name <- ""
current.file <- ""
current.fasta <- ""
for (i in 1:length(fasta.files)) {
  output.name <- paste(output.directory, strsplit(fasta.files[i], "\\.")[[1]][1], ".phylip", sep = "")
  current.file <- paste(path.to.directory, fasta.files[i], sep = "")
  current.fasta <- read.fasta(current.file)
  dat2phylip(current.fasta, outfile = output.name)
  output.name <- ""
  current.file <- ""
  current.fasta <- ""
}
