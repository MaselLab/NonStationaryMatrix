Pipeline readme

Steps:

1. RAxML to build the initial domain tree
	Input: Multiple sequence alignment for a Pfam domain and a matrix (usually JTT+G)
	Output: an unrooted maxmimum likelihood domain tree.

2. Notung to root the output tree from RAxML
	There are no scripts for this step! Notung uses batch processing to deal with a large amount of files at once.
	See the Notung manual for how to do this step.

3. TreeFix to reconcile a domain tree with a species tree.
	Input: Rooted domain tree, a matrix (same as used by RAxML, usually JTT+G), and a species tree.
	Output: Reconciled rooted domain tree.

4. Luke Kim's scripts to date the reconciled domain tree.
	Input: Reconciled rooted domain tree, dated species tree, and a multiple sequence alignment.
	Output: Reconciled rooted domain tree with branch lengths.