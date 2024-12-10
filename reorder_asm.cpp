#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
#include <queue>
#include <unordered_set>
#include <stdexcept>
#include <regex>

class InstructionGraph {
public:
    class InstructionNode {
    public:
        std::string cmd_line;
        std::string cmd;
        std::string dest;
        std::vector<std::string> srcs;
        std::unordered_set<InstructionNode*> dependents;
        std::unordered_set<InstructionNode*> depends_on;

        InstructionNode(const std::string& cmd_line) : cmd_line(cmd_line) {
            split_cmd_line(cmd_line);
        }

        bool operator<(const InstructionNode& other) const {
            return dependents.size() < other.dependents.size();
        }

    private:
        void split_cmd_line(const std::string& cmd_line) {
            // split by either comma or whitespace
            std::regex rgx("[ ,]+");
            std::sregex_token_iterator it(cmd_line.begin(), cmd_line.end(), rgx, -1);
            std::sregex_token_iterator end;
            std::vector<std::string> split_cmd(it, end);
            cmd = split_cmd[0];
            dest = split_cmd[1];
            // check that first character is an alphabet (otherwise its an immediate and we don't care)
            for (int i = 2; i < split_cmd.size(); i++) {
                if (std::isalpha(split_cmd[i][0])) {
                    srcs.push_back(split_cmd[i]);
                }
            }
        }
    };

    // add new instruction to the InstructionGraph
    void add_instr(const std::string& command_line) {
        auto* node = new InstructionNode(command_line);
        add_dependency(node);
    }

    // generate optimised out of order assembly
    // go through the current head and add instructions
    // then add new instructions to head
    std::vector<std::string> create_optimised_asm() {
        std::vector<std::string> new_asm_lst;
        std::make_heap(head.begin(), head.end(), Compare());

        while (!head.empty()) {
            InstructionNode* instr1 = extract_max();
            InstructionNode* instr2 = (head.empty()) ? nullptr : extract_max();

            new_asm_lst.push_back(instr1->cmd_line);
            add_next_instrs(instr1);
            
            // NOP when there is no other instr with no dependency
            if (instr2 == nullptr) {
                new_asm_lst.push_back("nop");
            } else {
                new_asm_lst.push_back(instr2->cmd_line);
                add_next_instrs(instr2);
            }
        }

        return new_asm_lst;
    }

private:

    // in the heap, compare priorities using the length of dependents
    // ie longer dependent list is higher priority (greedy approach)
    struct Compare {
        bool operator()(InstructionNode* a, InstructionNode* b) {
            return *a < *b;
        }
    };

    std::vector<InstructionNode*> nodes;
    std::vector<InstructionNode*> head;


    // update graph dependencies when adding a new instruction node
    void add_dependency(InstructionNode* new_instr) {
        bool no_dependency = true;
        for (auto* old_instr : nodes) {
            bool raw_d = false; // check for Read-After-Write (RAW) dependency
            for (const std::string& src : new_instr->srcs) {
                // Check if the source register matches the destination register of the old instruction
                if (src == old_instr->dest) {
                    raw_d = true;
                    break;
                }
            }

            bool war_d = false; // check for Write-After-Read (WAR) dependency
            for (const std::string& src : old_instr->srcs) {
                if (src == new_instr->dest) {
                    war_d = true;
                    break;
                }
            }

            // check for Write-After-Write (WAW) dependency
            bool waw_d = (new_instr->dest == old_instr->dest);

            if (raw_d || war_d || waw_d) {
                old_instr->dependents.insert(new_instr);
                new_instr->depends_on.insert(old_instr);
                no_dependency = false;
            }
        }

        nodes.push_back(new_instr);

        if (no_dependency) {
            head.push_back(new_instr);
        }
    }

    // function to get highest priority (max dependencies) in head heap
    InstructionNode* extract_max() {
        std::pop_heap(head.begin(), head.end(), Compare());
        InstructionNode* max = head.back();
        head.pop_back();
        return max;
    }

    void add_next_instrs(InstructionNode* completed_instr) {
        std::vector<InstructionNode*> next_instrs = get_next_instrs(completed_instr);
        for (auto* next_instr : next_instrs) {
            head.push_back(next_instr);
            std::push_heap(head.begin(), head.end(), Compare());
        }
    }
    
    // remove the completed instr from the other instructions' depends_on list
    // now see if we have any new instructions that have no dependents (can be executed next cycle)
    std::vector<InstructionNode*> get_next_instrs(InstructionNode* completed_instr) {
        std::vector<InstructionNode*> next_instrs;
        for (auto* instr : completed_instr->dependents) {
            instr->depends_on.erase(completed_instr);
            if (instr->depends_on.empty()) {
                next_instrs.push_back(instr);
            }
        }
        return next_instrs;
    }
};

bool verify_filenames(const std::string& filename) {
    auto pos = filename.rfind('.');
    if (pos == std::string::npos) return false;
    return filename.substr(pos + 1) == "s";
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file> [-o <output_file>]" << std::endl;
        return 1;
    }

    std::string input_file = argv[1];
    std::string output_file;

    if (argc == 4 && std::string(argv[2]) == "-o") {
        output_file = argv[3];
    }

    if (!verify_filenames(input_file)) {
        throw std::invalid_argument("Invalid input filename. Ensure that the file is an assembly file (.s).");
    }

    auto filename = input_file.substr(0, input_file.rfind('.'));
    std::string default_output = filename + "_reordered.s";

    if (output_file.empty()) {
        output_file = default_output;
    }

    if (!verify_filenames(output_file)) {
        output_file = default_output;
        std::cerr << "Invalid output filename. Defaulting to default output" << std::endl;
    }

    InstructionGraph instr_graph;

    std::ifstream source_file(input_file);
    if (!source_file.is_open()) {
        std::cerr << "Failed to open input file" << std::endl;
        return 1;
    }

    std::string line;
    while (std::getline(source_file, line)) {
        auto pos = line.find('#');
        if (pos != std::string::npos) {
            line = line.substr(0, pos);
        }
        if (!line.empty()) {
            instr_graph.add_instr(line);
        }
    }

    source_file.close();

    auto optimised_asm = instr_graph.create_optimised_asm();

    std::ofstream destination_file(output_file);
    if (!destination_file.is_open()) {
        std::cerr << "Failed to open output file" << std::endl;
        return 1;
    }

    for (const auto& asm_line : optimised_asm) {
        destination_file << asm_line << '\n';
    }

    destination_file.close();

    return 0;
}
