The purpose of the pipeline is to infer a substitution matrix using reconciled domain trees. To infer the best
substitution matrix, we need accurate evolutionary histories. Highly diverged sequences are suboptimal for
obtaining accurate histories, as far more changes have occurred than can be observed. We are better off using
highly conserved sequences, and therefore we use protein domains. Species tree information is also known to
improve gene tree inference, so we reconcile our domain trees with the TimeTree-derived species tree.
Reconciled domain trees should yield the most accurate evolutionary histories, and thus are the best choice
for matrix inference.

In order to make trees, we first need alignments. These were generated from annotated Pfam domains using
Clustal Omega. The alignmets, along with a starting matrix (we used JTT+G), are run through RAxML to obtain
initial, un-reconciled and unrooted domain trees. Unrooted trees cannot be reconciled with the species tree,
so we first root the initial domain trees using Notung, and then use TreeFix to reconcile the rooted domain
tree with the TimeTree-derived species tree. TreeFix only returns topology, but to infer a matrix, we need
branch lengths. To obtain branch lengths, we use Luke Kim's scripts. Reconciled domain trees with branch
lengths are then used for matrix inference.

See each step for input/output and other details. For more information, refer to the scripts themselves,
as they each contain comments explaining what they do and what their settings are.

1. RAxML to build the initial domain tree using the raxml_parallel.R script.
	Purpose: Make an initial unrooted domain tree for reconciliation.
	Input: Multiple sequence alignment (MSA) for a Pfam domain and a matrix (usually JTT+G)
		The MSA should be in FASTA format.
		The matrix is a setting in RAxML, which can be specified in the script.
	Output: an unrooted maxmimum likelihood domain tree.

2. Notung to root the output tree from RAxML using the notung_root_parallel.R script.
	Purpose: Root the initial tree for species tree reconciliation.
	The script currently does not call Notung; rather, it prepares file for Notung batch processing.
	Notung will need to be called manually.	See the Notung manual for how to do this step.

3. TreeFix to reconcile a domain tree with a species tree using the treefix_parallel.R script.
	Purpose: Improve domain tree topology by reconciling it with the TimeTree-derived species tree.
	Input: Rooted domain tree, a matrix (same as used by RAxML, usually JTT+G), the original alignment,
	       and a species tree.
	Output: Reconciled rooted domain tree.

4. Luke Kim's scripts to date the reconciled domain tree. The main script is "TreeCombinator.py".
	Purpose: Add branch length information to the reconciled domain tree.
	Input: Reconciled rooted domain tree, dated species tree, and a multiple sequence alignment.
	Output: Reconciled rooted domain tree with branch lengths.

The relevant scripts can be found in the associated folders (e.g. the "RAxML_scripts" folder contains raxml_parallel.R).

Several extra scripts are in the main directory. For what these do, please refer to the header for each script.

TO DO LIST:
Add a script/lines of code to exclude methionines at the start of the amino acid sequence. We should not be
inferring anything about the first methionine of the protein, and currently there is no check to see if
the first amino acid of an alignment is the first metnionine of a protein.

Determine how badly RAxML scales with number of sites. It appears to scale approximately linearly with
number of species, but a large number of species + a large number of sites results in very slow run times.
