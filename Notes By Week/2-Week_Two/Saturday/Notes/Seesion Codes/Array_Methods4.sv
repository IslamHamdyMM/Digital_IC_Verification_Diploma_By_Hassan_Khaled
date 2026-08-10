// ==================== Note ================================
// The array locator methods that return an index, such as find_index, return a queue of type int
// not integer.Your code may not compile if you use the wrong queue type with these statements

module Array_Method4;
    int count,total,d[] = '{9,1,8,3,4,4};

    initial begin
        count = d.sum(x) with(x > 7);   // 2 = sum{1,0,1,0,0,0}
        $dispaly("Sum with (x > 7) : %0d",count);
        total = d.sum(x) with((x > 7) * x); // 17 = sum{9,0,8,0,0,0}
        $display("Sum with((x > 7) * x) : %0d",total);
        count = d.sum(x) with(x < 8);   // 4 = sum{0,1,0,1,1,1}
        $display("Sum with(x < 8) : %0d",count);
        total = d.sum(x) with(x < 8 ? x : 0);   // 12 = sum{0,1,0,3,4,4}
        $display("Sum with(x < 8 ? x : 0) : %0d",total);
        count = d.sum(x) with(x == 4);  // 2 = sum{0,0,0,0,1,1}
        $display("Sum with(x == 4) : %0d",count);
    end
endmodule