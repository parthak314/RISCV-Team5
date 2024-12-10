module two_way_cache_top #(
    parameter   DATA_WIDTH = 32,                        // 1 word = 1 block = 4 bytes, so each block spans 4 ram addresses
                NUM_WORDS = 1024,                       // total number of data words stored i.e. num_sets * 2 (2-way so each set = 2 words)
                RAM_ADDR_WIDTH = 32
) (
    input   logic                       clk,
    input   logic                       en,             // access enable for cache (include this to prevent unnecessary evictions)
    // input   logic                       addr_mode,      // byte or word addressing, see memory_top
    input   logic [DATA_WIDTH-1:0]      wd,             // data to be written in
    input   logic                       we,             // write enable
    input   logic [DATA_WIDTH-1:0]      addr,           // target address for read data

    input   logic [DATA_WIDTH-1:0]      rd_from_ram,    // read from ram if miss
    output  logic                       re_from_ram,    // only read from ram if miss (to get rd_from_ram)

    output  logic [DATA_WIDTH-1:0]      wd_to_ram,      // word that is being evicted
    output  logic                       we_to_ram,      // write-enable = 1 if evicted
    output  logic [RAM_ADDR_WIDTH-1:0]  w_addr_to_ram,  // evicted word address in ram

    output  logic [BYTE_OFFSET-1:0]     offset,
    output  logic [DATA_WIDTH-1:0]      rd              // data that is output from reading cache
);
    // each set has 1 v bit and dirty bit per data block
    // i.e. 2-way cache will have 2 v bits and 2 dity bits per set (1 for each data block)
    localparam V_BIT_SIZE = 1;
    localparam DIRTY_BIT_SIZE = 1;
    localparam BYTE_SIZE = 8; // 8 bits in one byte
    localparam BYTE_OFFSET = $clog2(DATA_WIDTH / BYTE_SIZE); // addr offset of 2 bits (recall that least sig 2 bits are implicity always 2'b00 for 32 bits)

    // each set has 1 lru bit in total
    localparam LRU_BIT_SIZE = 1;                    // identify which block is least recently used in the set 
    localparam NUM_SETS = NUM_WORDS / 2;            // num_sets = num_words / number of ways in set (2 way set)
    localparam CACHE_ADDR_WIDTH = $clog2(NUM_SETS); // 9 bits
    localparam TAG_SIZE = RAM_ADDR_WIDTH - CACHE_ADDR_WIDTH - BYTE_OFFSET; // tag bits = 32 - index(9) - offset(2) = 21
    localparam SET_SIZE = (DATA_WIDTH + V_BIT_SIZE + DIRTY_BIT_SIZE + TAG_SIZE) * 2 + LRU_BIT_SIZE; // 111 bits!

    /*
    cache_addr_width (index) is 9 bits because we are storing 512 sets. [log2(512)]

    32-bit RAM address translated to cache addressing format
    bits ->  |  [31:11]   |   [10:2]   |   [1:0]   
    ---------------------------------------------
                TAG(21)   |  INDEX(9)  | BYTE OFFSET(2)

    overhead for each word (word = 32 bit data stored in memory):
    bits ->  |   1   |   1       | 21  | 32         total = 1 + 1 + 21 + 32 (55)
    -----------------------------------------
              V bit | Dirty bit | Tag | Word

    two_way cache set format:
    bits ->  |   1     |            55                |             55                          total = 1 + 55 + 55 (111)
    ---------------------------------------------------------------------------------  
            | LRU bit | Overhead for Word 1 | Word 1 | Overhead for Word 0 | Word 0
    */

    logic [SET_SIZE-1:0]                set_data;
    logic [SET_SIZE-1:0]                updated_set_data;
    logic                               we_to_cache;

    logic [CACHE_ADDR_WIDTH-1:0]        target_set;
    logic [TAG_SIZE-1:0]                target_tag;

    assign target_set   = addr[(CACHE_ADDR_WIDTH + BYTE_OFFSET - 1):BYTE_OFFSET];  // [10:2] INDEX - identify the set
    assign target_tag   = addr[RAM_ADDR_WIDTH-1:(CACHE_ADDR_WIDTH + BYTE_OFFSET)]; // [31:11] TAG - identify unique RAM address
    assign offset       = addr[BYTE_OFFSET-1:0];                                   // [1:0] BYTE OFFSET - identify desired byte within block

    two_way_cache_controller cache_controller_mod (
        .en(en),                    // read enable for cache
        // .addr_mode(addr_mode),
        .we(we),
        .wd(wd),
        .target_set(target_set),    // INDEX taken from RAM address we are trying to retrieve
        .target_tag(target_tag),    // TAG taken from RAM address we are trying to retrieve
        // .offset(offset),
        .set_data(set_data),
        .re_from_ram(re_from_ram),
        .rd_from_ram(rd_from_ram),
        .data_out(rd),
        .updated_set_data(updated_set_data),
        .we_to_cache(we_to_cache),
        .evicted_word(wd_to_ram),
        .evicted_ram_addr(w_addr_to_ram),
        .we_to_ram(we_to_ram)
    );

    sram_cache cache (
        .clk(clk),
        .addr(target_set),          // INDEX used to locate the relevant cache set
        .wd(updated_set_data),
        .we(we_to_cache),
        .re(en), // we convert en to re, because it is impossible for we to be HIGH when en is LOW, so write doesn't need an en check
        .rd(set_data)               // relevant cache set data fed back to cache controller to process metadata (lru, v & dirty bit)
    );

endmodule
