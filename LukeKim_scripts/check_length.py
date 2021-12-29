import os


def check_length(file_name):
    with open(file_name, 'r') as file:
        lines = file.readlines()
        i = 0
        count = 0
        while i < len(lines):
            if lines[i].startswith(">"):
                count += 1
            i += 1
        return count > 300


def main():
    count_file = 0

    alignments_path = "/groups/masel/mig2020/extra/ljkosinski/Alignments/"

    alignments_path_directory = os.listdir(alignments_path)

    for directory in alignments_path_directory:
        if directory.startswith("Pfam") and directory.endswith("00"):
            alignments_subpath = os.listdir(alignments_path + directory)
            for file in alignments_subpath:
                if file.startswith("PF") and file.endswith(".fasta"):
                    file_name = alignments_path + directory + "/" + file
                    if check_length(file_name):
                        count_file += 1

    print(count_file)


main()
