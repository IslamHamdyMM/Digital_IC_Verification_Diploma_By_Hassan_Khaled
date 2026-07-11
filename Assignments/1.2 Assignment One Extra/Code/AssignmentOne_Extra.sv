module AssignmentOne_Extra;

    // never needs X/Z means 2 states and from 0 to 255 means 8 bits which equal 1 byte
    byte unsigned b;
    // from -32000 to 32000 means 16 bits using shortint 16 bits size and signed by default
    shortint      c;
    // including X/Z means 4 states use logic
    logic   [3:0] d;


    // fixed set of whole number weights means Fixed Array in order means Packed Array
    bit [4:0] [2:0] Packed_Array   = '{1, 2, 3, 4, 5};
    // you never need to treat these weights as a single vector of adjacent elements means Unpacked Array 
    bit [2:0] Unpacked_Array [4:0] = '{1, 2, 3, 4, 5};
  
    //Used an unpacked array of packed pairs to keep A/B and C/D 
    //internally contiguous while forcing a non-contiguous separation between the two pairs.
    typedef bit [1:0][7:0] gain_pair_t;
    gain_pair_t gain_table [2];

    // The struct type reg_t is used to define a register with a name, address, and reset value.
    // The regfile array is an array of reg_t structures that can hold multiple registers.
    typedef struct {
        string name;
        byte unsigned address;
        byte unsigned Reset_Value;
    } reg_t;

    reg_t regfile [0:2];

    // I used a union type reg_view_u to allow access to the same data as either an integer or a byte.
    typedef union {
        int First;
        bit [7:0] Second;
    } reg_view_u;

    reg_view_u acc;

    //I used a dynamic array of 32-bit logic values because it can change size during simulation and 
    //can hold a variable number of 32-bit values.
    logic [31:0] trans_monitor [];

    initial begin
        $display("\n======================= Part A =======================");
        b = 250;
        $display("\nValue of b: %0d",b);
        c = -12345;
        $display("\nValue of c: %0d",c);
        d = 4'b1101;
        #5;
        $display("\nValue of d: %0b",d);

        $display("\n======================= Part B =======================");

        $display("\n=======================    1   =======================");

        $display("\nPacked Array  : %p",Packed_Array);
        $display("\nUnpacked Array: %p",Unpacked_Array);

        $display("\n=======================    2   =======================");

        gain_table[0] = '{10, 20};
        gain_table[1] = '{30, 40};
        $display("Gain Table [A,B],[C,D]: %p", gain_table);

        $display("\n=======================    3   =======================");

        regfile[0] = '{name:"CTRL"  , address:8'h00 , Reset_Value:8'h01};
        regfile[1] = '{name:"STATUS", address:8'h04 , Reset_Value:8'h00};
        regfile[2] = '{name:"DATA"  , address:8'h08 , Reset_Value:8'hFF};
        $display("\nRegister File: %p",regfile);

        $display("\n=======================    4   =======================");

        acc.First = 32'h12345678;
        $display("\nPrediction of byte value = 'h78");
        $display("\nActual Output First: %0h, Actual Output Second: %0h", acc.First, acc.Second);

        acc.First = 8'h12;
        $display("\nActual Output First after change: %0h, Actual Output Second after change: %0h", acc.First, acc.Second);

        $display("\n======================= Part C ========================");

        trans_monitor = new[5]; 
        trans_monitor = '{32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hCCCC_CCCC, 32'hDDDD_DDDD, 32'hEEEE_EEEE};
        $display("Dynamic Array (Monitored Transactions): %p", trans_monitor);

        $display("\n===========================completed=======================");
         
    end

    
endmodule