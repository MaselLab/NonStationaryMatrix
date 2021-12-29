import os

def compare_files(in_file, out_file):
    input_content = ""
    output_content = ""
    with open(in_file, 'r') as input_file:
        lines = input_file.readlines()
        for line in lines:
            input_content += line.strip("\n")
    with open(out_file, 'r') as input_file:
        lines = input_file.readlines()
        for line in lines:
            output_content += line.strip("\n")
    return input_content == output_content

def main():
    count_file_change = 0

    alignments_path = "/groups/masel/mig2020/extra/ljkosinski/Alignments/"

    alignments_path_directory = os.listdir(alignments_path)

    for directory in alignments_path_directory:
        if directory.startswith("Pfam") and directory.endswith("00"):
            alignments_subpath = os.listdir(alignments_path + directory)
            alignemnts_outpath = "/home/u8/anhnguyenphung/CleanAlignments/" + directory + "/"
            for file in alignments_subpath:
                if file.startswith("PF") and file.endswith(".fasta"):
                    in_file = alignments_path + directory + "/" + file
                    out_file = alignemnts_outpath + file
                    if not compare_files(in_file, out_file):
                        count_file_change += 1

    print(count_file_change)

main()
