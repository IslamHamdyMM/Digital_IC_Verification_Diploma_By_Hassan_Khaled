module datatype_tb;

    bit a_bit           = 1'b1;
    logic b_logic       = 1'b0;
    logic[3:0] c_logic4 = 4'b1111;

    byte d_byte      = -5;
    shortint e_short = -100;
    int f_int        = 200;
    longint g_long   = -1000;

    logic signed [3:0] h_signed_logic = 4'sb1000;

    initial begin
        
        $display("a_bit                              = %0d", a_bit);
        $display("b_logic                            = %0d", b_logic);
        $display("c_logic4                           = %0d", c_logic4);

        $display("d_byte                             = %0d", d_byte);
        $display("e_short                            = %0d", e_short);
        $display("f_int                              = %0d", f_int);
        $display("g_long                             = %0d", g_long);

        $display("h_signed_logic (bin)               = %0b", h_signed_logic);
        $display("h_signed_logic (dec)               = %0d", h_signed_logic);

        $display("Sum of unsigned + signed (15 + -5) = %0d", c_logic4 + d_byte);
        $display("\n==================== Done ====================");

    end
    
endmodule