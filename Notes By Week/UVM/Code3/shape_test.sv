import Rectangle_Class::*;
import Square_Class::*;

program shape_test;
    initial begin 
        Square square = new(5);
        Rectangle rectangle = new(8,4);

        square.display();
        rectangle.display();

        $finish();
    end
endprogram

