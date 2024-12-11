module stall_top (
    input logic         cache_miss,
    input logic         trigger,

    output logic        out
);

    assign out = (trigger || cache_miss);

endmodule
