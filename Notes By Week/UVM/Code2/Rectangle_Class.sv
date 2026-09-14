package class_Rectangle;
class Rectangle;

    int l,w;

    function new(int l, int w);
        this.l = l;
        this.w = w;
    endfunction

    function int get_area();
        return l * w;
    endfunction

    function void display();
        $display("Rectangle: Length = %0d, Width = %0d, Area = %0d",l,w,get_area());
    endfunction

endclass
endpackage