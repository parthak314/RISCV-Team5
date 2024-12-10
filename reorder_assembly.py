import argparse
import heapq

class InstructionGraph:

    class InstructionNode:
        def __init__(self, cmd_line):
            self.cmd_line = cmd_line
            self.cmd, self.dest, self.src = self.split_cmd_line(cmd_line)
            self.dependents = set()
            self.depends_on = set()

        def __lt__(self, other):
            # return biggest in heap not smallest (hence negative)
            return -len(self.dependents) < -len(other.dependents)

        def split_cmd_line(self, cmd_line: str) -> tuple[str, str, str]:
            split_cmd = cmd_line.split()
            cmd = split_cmd[0]
            dest = split_cmd[1]
            src = split_cmd[2:]
            return cmd, dest, src

    def __init__(self):
        self.nodes = []
        self.head = []

    def add_instr(self, command_line: str) -> None:
        node = self.InstructionNode(command_line)
        self._add_dependency(node)

    def create_optimised_asm(self) -> list[str]:
        new_asm_lst = []
        heapq.heapify(self.head)
        while self.head:
            if len(self.head) == 1:
                instr1 = heapq.heappop(self.head)
                instr2 = None
            else:
                instr1 = heapq.heappop(self.head)
                instr2 = heapq.heappop(self.head)

            new_asm_lst.append(instr1.cmd_line)
            self._add_next_instrs(instr1)
            
            if instr2 is None:
                new_asm_lst.append("nop")
            else:
                new_asm_lst.append(instr2.cmd_line)
                self._add_next_instrs(instr2)

        return new_asm_lst

    def _add_dependency(self, new_instr: InstructionNode) -> None:
        no_dependency = True
        for old_instr in self.nodes:
            if (any(src == old_instr.dest for src in new_instr.src) or # check for Read-After-Write (RAW) dependency
            new_instr.dest == old_instr.dest): # check for Write-After-Write (WAW) dependency
                old_instr.dependents.add(new_instr)
                new_instr.depends_on.add(old_instr)
                no_dependency = False

        self.nodes.append(new_instr)

        if no_dependency:
            self.head.append(new_instr)

    def _add_next_instrs(self, completed_instr: InstructionNode) -> None:
        next_instrs = self._get_next_instrs(completed_instr)
        for next_instr in next_instrs:
            heapq.heappush(self.head, next_instr)

    def _get_next_instrs(self, completed_instr: InstructionNode) -> InstructionNode:
        next_instrs = []
        for instr in completed_instr.dependents:
            instr.depends_on.remove(completed_instr)
            if not instr.depends_on:
                next_instrs.append(instr)
        return next_instrs

def verify_filenames(filename: str) -> bool:
    split_file = filename.split(".")
    if len(split_file) < 2:
        return False
    ext = split_file[-1]
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
    
    filename = input_file.rsplit('.', 1)[0]
    default_output = f"{filename}_reordered.s"

    if output_file is None:
        output_file = default_output

    if not verify_filenames(output_file):
        output_file = default_output
        raise UserWarning("Invalid output filename. Defaulting to default output")
    
    instr_graph = InstructionGraph()
    
    with open(input_file, "r") as source_file:
        for line in source_file:
            command_line = line.strip().split("#")[0] # remove comments
            if len(command_line) > 0:
                instr_graph.add_instr(command_line)

    optimised_asm = instr_graph.create_optimised_asm()

    with open(output_file, "w") as destination_file:
        for line in optimised_asm:
            destination_file.write(line + '\n')