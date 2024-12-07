`include "./memory/two_way_cache_controller.sv"
`include "./memory/sram.sv"

module two_way_cache_top #(
    parameter   DATA_WIDTH = 32, // 32 bit data stored in each ram address
                NUM_WORDS = 1024, // number of data words stored in total. ie num_sets * 2 (since 2 way)
                RAM_ADDR_WIDTH = 32
) (
    input   logic                       clk,
    input   logic                       addr_mode, // byte or word addressing, see memory_top
    input   logic [DATA_WIDTH-1:0]      wd, // Data to be written in
    input   logic                       we, // Write enable
    input   logic [DATA_WIDTH-1:0]      addr, // target address for read data
    input   logic [DATA_WIDTH-1:0]      rd_from_ram, // read from ram if miss

    output  logic [DATA_WIDTH-1:0]      rd, // data that is output from reading
    output  logic [DATA_WIDTH-1:0]      wd_to_ram, // word that is being evicted
    output  logic                       we_to_ram, // boolean if evicted or not
    output  logic [RAM_ADDR_WIDTH-1:0]  w_addr_to_ram // evicted word address in ram
);
    // each set has 1 v bit and dirty bit per data block
    // ie 2-way cache will have 2 v bits and 2 dity bits per set (1 for each data block)
    localparam V_BIT_SIZE = 1;
    localparam DIRTY_BIT_SIZE = 1;
    localparam BYTE_SIZE = 8; // 8 bits in one byte
    localparam BYTE_OFFSET = $clog2(DATA_WIDTH / BYTE_SIZE); // addr offset of 2 bits (recall that least sig 2 bits are implicity always 2'b00 for 32 bits)

    // each set has 1 lru bit in total
    localparam LRU_BIT_SIZE = 1; // indicates which of the words in the set are the least recently used
    localparam NUM_SETS = NUM_WORDS / 2; // num_sets = num_words / number of ways in set (2 way set)
    localparam CACHE_ADDR_WIDTH = $clog2(NUM_SETS); // 9 bits
    localparam TAG_SIZE = RAM_ADDR_WIDTH - CACHE_ADDR_WIDTH - BYTE_OFFSET; //  bits (32 - 9 - 2)
    localparam SET_SIZE = (DATA_WIDTH + V_BIT_SIZE + DIRTY_BIT_SIZE + TAG_SIZE) * 2 + LRU_BIT_SIZE; // 111 bits!

    /*
    overhead for each word (word = 32 bit data stored in memory):
     V bit | Dirty bit | tag | Word
    two_way cache set format:
    TODO: make this more readable
    | LRU bit | V bits | Dirty Bits | Tags | Words
    */

    logic [SET_SIZE-1:0]                set_data;
    logic [SET_SIZE-1:0]                updated_set_data;
    logic                               we_cache;

    logic [CACHE_ADDR_WIDTH-1:0]        target_set;
    logic [TAG_SIZE-1:0]                target_tag;
    logic [BYTE_OFFSET-1:0]             offset;

    assign target_set = addr[(CACHE_ADDR_WIDTH + BYTE_OFFSET - 1):BYTE_OFFSET];
    assign target_tag = addr[RAM_ADDR_WIDTH-1:(CACHE_ADDR_WIDTH + BYTE_OFFSET)];
    assign offset = addr[BYTE_OFFSET-1:0]; // for reading from other byte positions in the set

    two_way_cache_controller cache_controller_mod (
        .addr_mode(addr_mode),
        .we(we),
        .wd(wd),
        .target_set(target_set), // RAM address we are trying to retrieve
        .target_tag(target_tag),
        .offset(offset),
        .set_data(set_data),
        .rd_from_ram(rd_from_ram),
        .data_out(rd),
        .updated_set_data(updated_set_data),
        .we_cache(we_cache),
        .evicted_word(wd_to_ram),
        .evicted_ram_addr(w_addr_to_ram),
        .we_to_ram(we_to_ram)
    );

    sram cache (
        .clk(clk),
        .addr(target_set),
        .wd(updated_set_data),
        .we(we_cache),
        .rd(set_data)
    );

endmodule
