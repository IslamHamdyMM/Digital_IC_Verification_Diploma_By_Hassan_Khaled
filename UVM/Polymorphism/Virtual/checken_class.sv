package chicken_pkg;

import animal_pkg ::*;

class chicken extends animal;

	function new(int age);
		super.new(age);
	endfunction : new

	function void make_sound();
		$display("chicken says BAAAK");
	endfunction : make_sound

endclass : chicken

endpackage