package class_square;
class Square;

    int side;

    function new(int side);
        this.side = side;
    endfunction

    function int get_area();
        return side * 2;
    endfunction

    function void display();
        $display("Square: side = %0d, Area = %0d", side, get_area());
    endfunction

endclass
endpackage
