class Transaction;
    rand logic [2:0] x;
    rand logic [2:0] y;
    rand logic [2:0] z;

    // First constraint 
    /*constraint x_y_c{
        x > 3;
        y < 3;
    }*/

    // Second constraint 
    /*constraint x_y_c{
        x == 3;
        y < 3;
    }*/

    // Third constraint
    /*constraint x_y_c{
        x < y < z;
    }*/ // Wrong

    // Fourth Constraint 
    /*constraint x_y_c{
        x < y;
        y < z;
    }*/

    

endclass

module tb;
    Transaction tr;
    logic [2:0] x;
    logic [2:0] y;
    logic [2:0] z;

    design_tst dut(.*);

    initial begin
        tr = new();
        for(int i = 0; i < 9 ; i++) begin
            assert(tr.randomize()) else $finish();
            x = tr.x;
            y = tr.y;
            z = tr.z;
            $display("x = %d , y = %d , z = %d \n", x, y, z);
            #1ns;
        end
    end
endmodule
