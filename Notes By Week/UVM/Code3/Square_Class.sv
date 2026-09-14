package Square_Class;
    import Rectangle_Class::*;

    class Square extends Rectangle;
        int side;

        function new(int side);
            super.new(.l(side),.w(side));
        endfunction
    endclass
endpackage