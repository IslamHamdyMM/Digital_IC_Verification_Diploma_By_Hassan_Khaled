module Array_Methods1;

    byte b[$] = {2,3,4,5};
    int w;
    
    initial begin
        w = b.sum(); // w = 14 = 2 + 3 + 4 + 5
        $display("Sum of the queue elements = %0d", w);
        w = b.product(); // w = 120 = 2 * 3 * 4 * 5
        $display("Multiplication of the queue elements = %0d", w);
        w = b.and(); // w = 0000_0000 = 2 & 3 & 4 & 5
        $display("Anding of the queue elements = %0h", w);
        w = b.or(); // w = 0000_0111 = 2 | 3 | 4 | 5
        $display("Oring of the queue elements = %0h", w);
    end
endmodule