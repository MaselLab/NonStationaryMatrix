import os


def main():

    alignments_path = "/groups/masel/mig2020/extra/ljkosinski/Alignments/"

    alignments_path_directory = os.listdir(alignments_path)

    for directory in alignments_path_directory:
        if directory.startswith("Pfam") and directory.endswith("00"):
            alignments_subpath = os.listdir(alignments_path + directory)
            alignemnts_outpath = "/home/u8/anhnguyenphung/CleanAlignments/" + directory + "/"
            for file in alignments_subpath:
                if file.startswith("PF") and file.endswith(".fasta"):
                    os.system(f'/home/u8/anhnguyenphung/trimal/source/trimal -noallgaps -automated1 '
                              f'-in {alignments_path + directory}/{file} -out {alignemnts_outpath+file} -fasta')


main()
