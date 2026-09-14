import class_square::*;
import class_Rectangle::*;

program shape_test;
    initial begin
        Square square       = new(5);
        Rectangle rectangle = new(8, 4);

        square.display();
        rectangle.display();

        $finish();
    end
endprogram