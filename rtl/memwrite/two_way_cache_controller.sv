module two_way_cache_controller #(
    parameter   SET_SIZE = 111, // see two_way_cache_top.sv for calculation
                DATA_WIDTH = 32,
                TAG_SIZE = 21,
                CACHE_ADDR_WIDTH = 9,
                // BYTE_OFFSET = 2,
                RAM_ADDR_WIDTH = 32
) (
    // control inputs from memory_top
    input   logic                           en, // access en signal to prevent unncessary evictions
    // input   logic                           addr_mode,
    input   logic                           we,
    input   logic [DATA_WIDTH-1:0]          wd,
    input   logic [CACHE_ADDR_WIDTH-1:0]    target_set,
    input   logic [TAG_SIZE-1:0]            target_tag,
    // input   logic [BYTE_OFFSET-1:0]         offset,

    // set input from cache
    input   logic [SET_SIZE-1:0]            set_data,

    // input from RAM
    input   logic [DATA_WIDTH-1:0]          rd_from_ram,
    output  logic                           re_from_ram, // only read from RAM on miss (then get rd_from_ram)
    // read output from cache
    output  logic [DATA_WIDTH-1:0]          data_out,

    // write back to cache when any changes to current set
    output  logic [SET_SIZE-1:0]            updated_set_data,
    output  logic                           we_to_cache,

    // write back to RAM when evicting word
    output  logic [DATA_WIDTH-1:0]          evicted_word,
    output  logic [RAM_ADDR_WIDTH-1:0]      evicted_ram_addr,
    output  logic                           we_to_ram
);
    logic                                   lru_bit;
    logic [1:0]                             v_bits, dirty_bits;
    logic [DATA_WIDTH-1:0]                  words [1:0];
    logic [TAG_SIZE-1:0]                    tags [1:0];

    assign lru_bit = set_data[110];
    assign v_bits = {set_data[109], set_data[54]};
    assign dirty_bits = {set_data[108], set_data[53]};
    assign tags = {set_data[107:87], set_data[52:32]};
    assign words = {set_data[86:55], set_data[31:0]};

    logic [1:0]                         hits;

    assign hits[0] = (v_bits[0] && (tags[0] == target_tag));
    assign hits[1] = (v_bits[1] && (tags[1] == target_tag));

    logic                               correct_way; // which way has the right data at the end of it
    logic [TAG_SIZE-1:0]                evicted_tag;
    logic                               evicted_way; // whether to evict way 0 or way 1

    logic                               new_lru_bit;
    logic [TAG_SIZE-1:0]                new_tags [1:0];
    logic [1:0]                         new_v_bits;
    logic [DATA_WIDTH-1:0]              new_words [1:0];
    logic [1:0]                         new_dirty_bits;

    always_comb begin
        correct_way = 1'b0;

        re_from_ram = 1'b0; // by default, do not read from RAM (only read when miss)
        evicted_way = 1'b0;
        evicted_tag = {TAG_SIZE{1'b0}};
        we_to_ram = 1'b0;
        evicted_word = {DATA_WIDTH{1'0}};
        evicted_ram_addr = {RAM_ADDR_WIDTH{1'0}};
        
        new_lru_bit = lru_bit;
        new_tags = tags;
        new_words = words;
        new_v_bits = v_bits;
        new_dirty_bits = dirty_bits;

        data_out = {DATA_WIDTH{1'b0}};

        if (en) begin // only do operations when en is HIGH
            if (hits[0] || hits[1]) begin 
                correct_way = hits[1];          // if hit
                data_out = words[correct_way];
            end
            else begin // if miss
                evicted_way = (~v_bits[1] || lru_bit);

                // if need to write back to RAM: only when evicted word is valid and is dirty (ie not the same as in RAM)
                if (v_bits[evicted_way] && dirty_bits[evicted_way]) begin
                    // prepare to write evicted way back to RAM
                    we_to_ram = 1'b1;
                    evicted_word = words[evicted_way];
                    evicted_tag = tags[evicted_way];
                    evicted_ram_addr = {evicted_tag, target_set, 2'b0};
                end
                // else throw away the evicted data because it's not relevant

                // update with new data from RAM
                re_from_ram = 1'b1; // ASSUMPTION: this system assumes that RAM read is immediate
                new_words[evicted_way] = rd_from_ram;
                new_tags[evicted_way] = target_tag;
                new_v_bits[evicted_way] = 1'b1;
                new_dirty_bits[evicted_way] = 1'b0;
                correct_way = evicted_way;

                data_out = rd_from_ram;
            end

            new_lru_bit = ~correct_way; // update LRU as the other way in set (not used this cycle)

            if (we) begin // write to cache
                new_words[correct_way] = wd;
                new_dirty_bits[correct_way] = 1'b1; // update dirty bit
            end
        end
    end

    assign updated_set_data = {
        new_lru_bit,
        new_v_bits[1],
        new_dirty_bits[1],
        new_tags[1],
        new_words[1],
        new_v_bits[0],
        new_dirty_bits[0],
        new_tags[0],
        new_words[0]
    };

    assign we_to_cache = (en && (updated_set_data != set_data));

endmodule
