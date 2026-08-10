
module lab4_tb;

  logic [7:0] a, b, sum;

  adder uut (
    .a(a),
    .b(b),
    .sum(sum)
  );

function automatic logic [7:0] F_Sum(ref logic [7:0] x,ref logic [7:0] y);
  return (x + y);
endfunction

task automatic Check_Sum(ref logic [7:0] sum,ref logic [7:0] x,ref logic [7:0] y);
  #10;
  if(sum != F_Sum(x,y))
    $display("[ERROR] a = %0d, b = %0d, sum = %0d, expected = %0d", x, y, sum, F_Sum(x,y));
  else
    $display("[PASSED] a = %0d, b = %0d, sum = %0d, expected = %0d", x, y, sum, F_Sum(x,y));
endtask

  initial begin
    $display("-------------------------------------------------");
    $display("              Adder Testbench                    ");
    $display("-------------------------------------------------");

    a = 8'd10;b = 8'd20;
    Check_Sum(sum,a,b);
    a = 8'd15;b = 8'd25;
    Check_Sum(sum,a,b);
    a = 8'd100;b = 8'd55;
    Check_Sum(sum,a,b);
    a = 8'd200;b = 8'd44;
    Check_Sum(sum,a,b);

  $display("-------------------------------------------------");
  $display("                 Lab 4 Done                      ");
  $display("-------------------------------------------------");
    
    $finish;

  end

endmodule
