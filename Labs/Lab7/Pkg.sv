package alu_pkg;
    typedef enum logic [3:0] {
            ADD   = 4'h0;  
            SUB   = 4'h1;
            MUL   = 4'h2;
            DIV   = 4'h3;
            AND   = 4'h4;
            OR    = 4'h5;
            NAND  = 4'h6;
            NOR   = 4'h7;
            XOR   = 4'h8;
            XNOR  = 4'h9;
            EQUAL = 4'hA;
            GT    = 4'hB;
            LT    = 4'hC;
            SHR   = 4'hD;
            SHL   = 4'hE;
            NoOp  = 4'hF;
    } alu_fun_e;

endpackage