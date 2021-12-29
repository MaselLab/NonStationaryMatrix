import sys

def compare(infile, outfile):
    input_content = ""
    output_content = ""
    with open(infile, 'r') as input_file:
        lines = input_file.readlines()
        for line in lines:
            input_content += line.strip("\n")
    with open(outfile, 'r') as input_file:
        lines = input_file.readlines()
        for line in lines:
            output_content += line.strip("\n")
    print(input_content == output_content)

def main():
    infile = sys.argv[1]
    outfile = sys.argv[2]
    compare(infile, outfile)

if __name__ == '__main__':
    main()
