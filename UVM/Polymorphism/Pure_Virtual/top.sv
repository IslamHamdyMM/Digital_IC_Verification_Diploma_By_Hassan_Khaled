import animal_pkg  ::*;
import lion_pkg    ::*;
import chicken_pkg ::*;

module top;

	initial begin

	lion lion_h;
	chicken chicken_h;
	animal animal_h;

	lion_h = new(15);
	lion_h.make_sound();
	$display("The lion is %0d years old", lion_h.age);

	chicken_h = new(1);
	chicken_h.make_sound();
	$display("The chicken is %0d years old",chicken_h.age);

	animal_h = lion_h;
	animal_h.make_sound();
	$display("The animal is %0d years old", animal_h.age);

	animal_h = chicken_h;
	animal_h.make_sound();
	$display("The animal is %0d years old", animal_h.age);

	end

endmodule 