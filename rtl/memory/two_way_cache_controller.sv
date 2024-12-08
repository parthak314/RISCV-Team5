module two_way_cache_controller #(
    parameter   SET_SIZE = 111, // see two_way_cache_top.sv for calculation
                DATA_WIDTH = 32,
                TAG_SIZE = 21,
                CACHE_ADDR_WIDTH = 9,
                BYTE_OFFSET = 2,
                RAM_ADDR_WIDTH = 32
) (
    // read or write inputs
    input   logic                           addr_mode,
    input   logic                           we,
    input   logic [DATA_WIDTH-1:0]          wd,
    input   logic [CACHE_ADDR_WIDTH-1:0]    target_set,
    input   logic [TAG_SIZE-1:0]            target_tag,
    input   logic [BYTE_OFFSET-1:0]         offset,

    // cache set of the correct set index
    input   logic [SET_SIZE-1:0]            set_data,

    input   logic [DATA_WIDTH-1:0]          rd_from_ram, // TODO: set a mux to only read when miss
    

    // output to write
    output  logic [DATA_WIDTH-1:0]          data_out,

    // writing back to cache
    output  logic [SET_SIZE-1:0]            updated_set_data,
    output  logic                           we_cache,

    // update lru way to evict
    output  logic [DATA_WIDTH-1:0]          evicted_word,
    output  logic [RAM_ADDR_WIDTH-1:0]      evicted_ram_addr,
    output  logic                           we_to_ram // determine if evicted need to write back to ram
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

    // Read from cache and update LRU
    // if hit, update lru bit
    // if miss, evict lru and update value
    // then check if we need to write back to ram (dirty bit)

    // after checking hit and retrieving if miss, 
    // which block 0 or 1 is the correct block to read/write to.
    logic                               correct_way; // which way has the right data at the end of it
    logic [TAG_SIZE-1:0]                evicted_tag;
    logic                               evicted_way; // whether to evict way 0 or way 1

    logic                               new_lru_bit;
    logic [TAG_SIZE-1:0]                new_tags [1:0];
    logic [1:0]                         new_v_bits;
    logic [DATA_WIDTH-1:0]              new_words [1:0];
    logic [1:0]                         new_dirty_bits;

    always_comb begin
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

        if (hits[0] || hits[1]) correct_way = hits[1]; // if hit
        else begin
            evicted_way = (~v_bits[1] || lru_bit);

            if (v_bits[evicted_way]) begin
                // prepare to write evicted way back to RAM
                we_to_ram = dirty_bits[evicted_way];
                evicted_word = words[evicted_way];
                evicted_tag = tags[evicted_way];
                evicted_ram_addr = {evicted_tag, target_set, 2'b0};
            end
            // else throw away the evicted data because it's not valid

            // update with new data from RAM
            new_words[evicted_way] = rd_from_ram;
            new_tags[evicted_way] = target_tag;
            new_v_bits[evicted_way] = 1'b1;
            new_dirty_bits[evicted_way] = 1'b0;
            correct_way = evicted_way;
        end

        new_lru_bit = ~correct_way;

        if (we) begin // write to cache
            if (addr_mode) begin
                case (offset) // handle different offsets for SB
                    2'b00:      new_words[correct_way] = {new_words[correct_way][31:8], wd[7:0]};
                    2'b01:      new_words[correct_way] = {new_words[correct_way][31:16], wd[7:0], new_words[correct_way][7:0]};
                    2'b10:      new_words[correct_way] = {new_words[correct_way][31:24], wd[7:0], new_words[correct_way][15:0]};
                    2'b11:      new_words[correct_way] = {wd[7:0], new_words[correct_way][23:0]};
                    default:    new_words[correct_way] = {new_words[correct_way][31:8], wd[7:0]};
                endcase
            end else new_words[correct_way] = wd;

            new_dirty_bits[correct_way] = 1'b1; // update dirty bit
        end

        // read from cache address
        if (addr_mode) begin
            case (offset)
                2'b00:          data_out = {24'b0, new_words[correct_way][7:0]};
                2'b01:          data_out = {24'b0, new_words[correct_way][15:8]};
                2'b10:          data_out = {24'b0, new_words[correct_way][23:16]};
                2'b11:          data_out = {24'b0, new_words[correct_way][31:24]};
                default:        data_out = {24'b0, new_words[correct_way][7:0]};
            endcase
        end else                data_out = new_words[correct_way];
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

    assign we_cache = (updated_set_data != set_data);

endmodule
