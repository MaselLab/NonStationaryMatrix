import random


def create_file():
    content = ""
    with open("random_sequences.fasta", "w") as file:
        num_sequence = 7
        length_sequence = 25
        amino_acid_list = ['A', 'R', 'N', 'D', 'C', 'Q', 'E', 'G', 'H', 'I', 'L', 'K', 'M', 'F', 'P', 'S', 'T',
                           'W', 'Y', 'V', '-']
        for i in range(num_sequence):
            content += (">Row" + str(i+1) + "\n")
            for j in range(length_sequence):
                index = random.randint(0, 20)
                content += amino_acid_list[index]
            content += "\n"
        file.write(content)


def main():
    create_file()


main()
