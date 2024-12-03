# NOT IMPLEMENTED YET

import argparse

def verify_filenames(filename: str):
    split_file = filename.split(".")
    if len(split_file) != 2:
        return False
    ext = split_file[1]
    if ext == "s":
        return True
    return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Description of your program.")

    parser.add_argument('input_file', type=str, help='Path to the input file')
    parser.add_argument('-o', '--output', type=str, help='Path to the output file')

    args = parser.parse_args()

    input_file = args.input_file
    output_file = args.output


    # verify that all filenames are valid
    if not verify_filenames(input_file):
        raise NameError("Invalid input filename. Ensure that the file is an assembly file (.s).")
    
    filename = input_file.split(".")[0]
    default_output = f"{filename}_nop.s"

    if output_file is None:
        output_file = default_output

    if not verify_filenames(output_file):
        output_file = default_output
        raise UserWarning("Invalid output filename. Defaulting to default output")
    
    with open(input_file, "r") as sourcse_file:
        with open(output_file, "w") as destination_file:
            for line in source_file:
                command_line = line.strip().split("#") # remove comments
                split_command = command_line[0].split()
                print(split_command)
                if len(split_command) < 3:
                    destination_file.write(line)




