Pipeline the pipeline is designed to proceed in the following steps. See each step for input/output and
other details. For more information, refer to the scripts themselves, as they each contain comments explaining
what they do and what their settings are.

1. RAxML to build the initial domain tree using the raxml_parallel.R script.
	Input: Multiple sequence alignment (MSA) for a Pfam domain and a matrix (usually JTT+G)
		The MSA should be in FASTA format.
		The matrix is a setting in RAxML, which can be specified in the script.
	Output: an unrooted maxmimum likelihood domain tree.

2. Notung to root the output tree from RAxML using the notung_root_parallel.R script.
	The script currently does not call Notung; rather, it prepares file for Notung batch processing.
	Notung will need to be called manually.	See the Notung manual for how to do this step.

3. TreeFix to reconcile a domain tree with a species tree using the treefix_parallel.R script.
	Input: Rooted domain tree, a matrix (same as used by RAxML, usually JTT+G), and a species tree.
	Output: Reconciled rooted domain tree.

4. Luke Kim's scripts to date the reconciled domain tree. The main script is "TreeCombinator.py".
	Input: Reconciled rooted domain tree, dated species tree, and a multiple sequence alignment.
	Output: Reconciled rooted domain tree with branch lengths.

The relevant scripts can be found in the associated folders (e.g. the "RAxML_scripts" folder contains raxml_parallel.R).

Several extra scripts are in the main directory. For what these do, please refer to the header for each script.
