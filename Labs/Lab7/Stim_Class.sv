class stimulus;
    rand logic [7:0] A;
    rand logic [7:0] B;
    rand logic [3:0] ALU_FUN;
    rand logic RST;
    rand logic enable;
    bit clk;

    bit [2:0] idx;

    constraint RST_c {
        RST dist {1'b0 := 10, 1'b1 := 90};
    }

    constraint enable_c {
        enable dist { 1'b1 := 85, 1'b0 := 15};
    }

    constraint ALU_FUN_c {
        ALU_FUN dist { 4'hF := 5, [4'h0:4'hE] := 95};
    }

    constraint A_B_mul_add_c {
        if(ALU_FUN == 4'b0000 || ALU_FUN == 4'b0010) {
            A dist {8'h00 := 30,
                    8'h80 := 30,
                    8'h7F := 30,
                    [8'h01 : 8'h7E] := 5,
                    [8'h81 : 8'hFF] := 5};

            B dist {8'h00 := 30,
                    8'h80 := 30,
                    8'h7F := 30,
                    [8'h01 : 8'h7E] := 5,
                    [8'h81 : 8'hFF] := 5};
        }
        
    }

    constraint A_B_OR_c {
        (ALU_FUN == 4'b0101) -> {
            A == (8'b1 << idx);
            B dist {8'h00  := 90,
                    [8'h01 : 8'hFF] := 10};
        }
    }

    constraint A_B_XOR_c {
        (ALU_FUN == 4'b1000) -> {
            A == (8'b1 << idx);
            B dist {8'h00  := 90,
                    [8'h01 : 8'hFF] := 10};
        }
    }

    function string fun_name(logic [3:0] F);
        case(F)
            4'h0 : return "ADD";
            4'h1 : return "SUB";
            4'h2 : return "MUL";
            4'h3 : return "DIV";
            4'h4 : return "AND";
            4'h5 : return "OR";
            4'h6 : return "NAND";
            4'h7 : return "NOR";
            4'h8 : return "XOR";
            4'h9 : return "XNOR";
            4'hA : return "EQUAL";
            4'hB : return "GT";
            4'hC : return "LT";
            4'hD : return "SHR";
            4'hE : return "SHL";
            default : return "INV";
        endcase
    endfunction

    function void pre_randomize();
        $display("========== All Class Members Before Randomization ==========");
        $display(" RST     = %0b ",RST);
        $display(" enable  = %0b", enable);
        $display(" ALU_FUN = 4'h%02h (%s)",ALU_FUN,fun_name(ALU_FUN));
        $display(" A       = 8'h%02h", A);
        $display(" B       = 8'h%02h", B);
    endfunction

    function void post_randomize();
        idx = (idx + 1) % 8;

        $display("========== All Class Members After Randomization ==========");
        $display(" RST     = %0b ",RST);
        $display(" enable  = %0b", enable);
        $display(" ALU_FUN = 4'h%02h (%s)",ALU_FUN,fun_name(ALU_FUN));
        $display(" A       = 8'h%02h", A);
        $display(" B       = 8'h%02h", B);
    endfunction

    task drive(ref logic [7:0] A_dut,
               ref logic [7:0] B_dut,
               ref logic [3:0] ALU_FUN_dut,
               ref logic enable_dut,
               ref logic RST_dut);

        @(negedge clk);
        A_dut = A;
        B_dut = B;
        ALU_FUN_dut = ALU_FUN;
        enable_dut = enable;
        RST_dut = RST;
        $display("Drive ==> RST = %0b, enable = %0b, FUN = %s , A = 8'h%02h , B = 8'h%02h",
                            RST,enable,fun_name(ALU_FUN),A,B);
        @(negedge clk);
    endtask
endclass