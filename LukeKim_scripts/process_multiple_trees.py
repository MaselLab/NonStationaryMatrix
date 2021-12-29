import os, re
from string import ascii_letters


def main():
    species_tree_path = "/home/u8/anhnguyenphung/Pipeline/SpeciesTree.nwk"
    outfile_path = "/xdisk/masel/mig2020/extra/ljkosinski/TreesWBL/Pfam300/"
    domain_tree_and_seq_path = "/xdisk/masel/mig2020/extra/ljkosinski/Rooted/Pfam300/JTT_G/Reconciled/"

    domain_tree_and_seq_list = os.listdir(domain_tree_and_seq_path)

    for directory in domain_tree_and_seq_list:
        if directory.startswith("PF") and directory.endswith("_treefix"):
            domain_tree_and_seq_sublist = os.listdir(domain_tree_and_seq_path + directory)
            alignment_file = ""
            tree_file = ""
            for file in domain_tree_and_seq_sublist:
                if file.endswith(".fasta.align"):
                    alignment_file = file
                elif file.endswith(".reconciled"):
                    tree_file = file

            pfam_id = re.sub('[^A-Za-z0-9]+', '', alignment_file).strip(ascii_letters)

            alignment_file = domain_tree_and_seq_path + directory + "/" + alignment_file
            tree_file = domain_tree_and_seq_path + directory + "/" + tree_file

            output_tree_path = outfile_path + "PF" + pfam_id + ".nwk"

            with open(tree_file, 'r') as file:
                content = file.readlines()
            for i in range(len(content)):
                if ')n' in content[i]:
                    new_line = ''
                    for char in content[i]:
                        if char != 'n' and not char.isnumeric():
                            new_line += char
                    content[i] = new_line
            with open(tree_file, 'w') as file:
                file.writelines(content)

            os.system(f'python /home/u8/anhnguyenphung/Pipeline/LukeKim_scripts/TreeCombinator.py '
                    f'-d {tree_file} -s {species_tree_path} -a {alignment_file} -o {output_tree_path}')


main()
