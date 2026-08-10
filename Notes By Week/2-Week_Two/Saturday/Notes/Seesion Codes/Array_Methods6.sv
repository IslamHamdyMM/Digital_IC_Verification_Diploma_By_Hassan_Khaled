module Array_Methods6;

    int d[] = '{9,1,8,3,4,4};
    struct packed {bit[7:0] r,g,b;} c[]; // Array of structs
    c = '{'{r:7,g:4,b:9},'{r:3,g:2,b:9},'{r:5,g:2,b:1}};

    initial begin
        $display("Reversing d : %p",d.reverse());
        $display("Sorting d : %p",d.sort());
        $display("Reverse Sort d : %p",d.rsort());
        $display("Shuffling d : %p",d.shuffle());

        $display("Sorting c using r only : %p",c.sort with(item.r));
        $display("Sorting g first, then b : %p",c.sort(x) with({x.g,x.b}));
    end

endmodule
