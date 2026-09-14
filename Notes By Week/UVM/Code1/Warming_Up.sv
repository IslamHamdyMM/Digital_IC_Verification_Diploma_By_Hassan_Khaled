typedef struct {
    int length;
    int width;
} shape_t;

program shape_calculator;
    
    shape_t square;
    shape_t rectangle;

    initial begin
        square.length = 5;
        square.width  = 5;
        
        rectangle.length = 8;
        rectangle.width  = 4;

        $display("Square: Length = %0d, Width = %0d, Area = %0d",
                  square.length, square.width, square.length * square.width);

        $display("Rectangle: Length = %0d, Width = %0d, Area = %0d",
                  rectangle.length, rectangle.width, rectangle.length * rectangle.width);
        
        $finish; // End simulation
    end
endprogram