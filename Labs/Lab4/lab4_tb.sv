
module adder_tb;

  logic [7:0] a, b, sum;

  adder uut (
    .a(a),
    .b(b),
    .sum(sum)
  );

  function logic [7:0] sum1(logic[7:0] x, logic[7:0] y);
    return x + y;
  endfunction

  task automatic check_sum(logic [7:0] x, logic [7:0] y);
    #10
    if(sum != sum1(x, y))
      $display("[ERROR] a = %0d, b = %0d, sum = %0d, expected = %d", x, y, sum, sum1(x, y));
    else 
      $display("[PASSED] a = %0d, b = %0d, sum = %0d, expected = %d", x, y, sum, sum1(x, y));

  endtask

  initial begin
    $display("-------------------------------------------------");
    $display("              Adder Testbench                    ");
    $display("-------------------------------------------------");

    check_sum(8'd10, 8'd20);
   
    check_sum(8'd15, 8'd25);

    check_sum(8'd100, 8'd55);
    
    check_sum(8'd200, 8'd44);
    $finish;

  end

endmodule

