package Rectangle_Class;
    class Rectangle;
        int l,w;

        function new(int l,int w);
            this.l = l;
            this.w = w;
        endfunction

        function int Area();
            return l * w;
        endfunction

        function void display();
            $display("Length = %0d, Width = %0d, Area = %0d", l, w, Area());
        endfunction

    endclass
endpackage
