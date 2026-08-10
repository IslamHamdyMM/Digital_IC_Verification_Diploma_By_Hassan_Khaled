module Array_Method2;

    int f[6] = '{1,6,2,6,8,6};  // Fixed-size array
    int d[]  = '{2,4,6,8,10};   // Dynamic array
    int q[$] =  {1,3,5,7};      // Queue
    int tq[$];                  // Temporary queue for result

    initial begin
        tq = q.min(); // {1}
        $display("Minimum element in q = %0d",tq);
        tq = d.max(); // {10}
        $display("Maximum element in d = %0d",tq);
        tq = f.unique(); // {1,6,2,8}
        $display("f after remove repeated values : %p",tq);
    end
endmodule
