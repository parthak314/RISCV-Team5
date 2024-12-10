rm -rf obj_dir/

find ../rtl -type f -name "*.sv" > filelist.f

input_file="./hex.txt"
output_file="../rtl/program.hex"
temp_file=$(mktemp)

while read -r line; do
  echo "$line" | sed 's/../& /g' | sed 's/ $//' >> "$temp_file"
done < "$input_file"
mv "$temp_file" "$output_file"

verilator   -Wall --trace --cc ../rtl/memwrite/loadstore_parsing_unit.sv \
            --exe ./playground_tb.cpp \
            --prefix "Vdut" \
            -o Vdut \
            # -LDFLAGS "-lgtest -lgtest_main -lpthread" \

make -j -C obj_dir/ -f Vdut.mk Vdut
obj_dir/Vdut