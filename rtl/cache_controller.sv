// Perhaps use LRU array based implementation as per slide 21

module cache_controller #(
    parameter   ADDR_WIDTH = 64,
                DATA_WIDTH = 32,
                BLOCK_SIZE = 4,
                NUM_SETS = 256
) (
    input   logic                   clk,
    input   logic                   reset,
    input   logic [ADDR_WIDTH-1:0]  addr,
    input   logic                   mem_write_en,

    output  logic [DATA_WIDTH-1:0]  read_data,
    output  logic                   hit,
    output  logic                   miss
    output  logic                   write_back, 
    output  logic [ADDR_WIDTH-1:0]  wb_addr,    
    output  logic [DATA_WIDTH-1:0]  wb_data  
);
    // specify derived parameters (as per lecture slides)
    localparam  OFFSET = $clog2(BLOCK_SIZE); //2
    localparam  INDEX  = $clog2(NUM_SETS); //8
    localparam  TAG    = ADDR_WIDTH - INDEX - OFFSET; // 22

    logic   [TAG-1:0]     tag;
    logic   [OFFSET-1:0]  offset;
    logic   [INDEX-1:0]   index;
    logic   [DATA_WIDTH-1:0] data;

    assign tag = addr[ADDR_WIDTH-1:ADDR_WIDTH-TAG];
    assign index = addr[ADDR_WIDTH-TAG-1:ADDR_WIDTH-TAG-INDEX];
    assign offset = addr[DATA_WIDTH+OFFSET-1:DATA_WIDTH];
    assign data = addr[DATA_WIDTH-1:0];

    //cache arrays
    logic [TAG-1:0] tag_array [NUM_SETS-1:0][1:0];
    logic [DATA_WIDTH-1:0] data_array [NUM_SETS-1:0][1:0][BLOCK_SIZE-1:0];
    logic valid_array [NUM_SETS-1:0][1:0];
    logic dirty_array [NUM_SETS-1:0][1:0];
    logic lru_array [NUM_SETS-1:0];

    // hit detection
    logic hit0, hit1;

    assign hit0 = valid_array[index][0] && (tag_array[index][0] == tag);
    assign hit1 = valid_array[index][1] && (tag_array[index][1] == tag);
    assign hit = hit0 || hit1;
    assign miss = ~hit;

    // Reading from cache
    always_comb begin
        if (hit0)       read_data = data_array[index][0][offset];
        else if (hit1)  read_data = data_array[index][1][offset];
        else            read_data = '0;
    end

    // Writing to cache
    always_ff @(posedge clk) begin
        if (mem_write_en && hit) begin
            if (hit0) begin
                data_array[index][0][offset] <= data;
                dirty_array[index][0] <= 1;
            end else if (hit1) begin
                data_array[index][1][offset] <= data;
                dirty_array[index][1] <= 1;
            end 
        end
    end

    // Replacement on miss using lru
    logic way;

            // lru bit per set    
    always_ff @(posedge clk) begin
        if (reset)      lru_array <= '0;
        else if (miss)  lru_array[index] <= ~lru_array[index];

        if (hit) begin
            if (hit0)   lru_array[index] <= 1;
            if (hit1)   lru_array[index] <= 0;
        end       
    end


            // logic to determine which way to select for eviction
    always_comb begin
        if (!valid_array[index][0])         way = 0;
        else if (!valid_array[index][1])    way = 1;
        else                                way = lru_array[index];    
    end 

    always_ff @(posedge clk) begin
        if (miss) begin
            if (~way) begin
                tag_array[index][0] <= tag;
                valid_array[index][0] <= 1;
                dirty_array[index][0] <= 0;
            end else begin
                tag_array[index][1] <= tag;
                valid_array[index][1] <= 1;
                dirty_array[index][1] <= 0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (miss && dirty_array[index][way]) begin
            write_back <= 1;
            wb_addr <= {tag_array[index][way], index, offset};
            wb_data <= data_array[index][way][offset]
        end else write_back <= 0;
    end

    // reset logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_array <= '0;
            dirty_array <= '0;
            tag_array <= '0;
            lru_array <= '0;
        end
    end
    
endmodule