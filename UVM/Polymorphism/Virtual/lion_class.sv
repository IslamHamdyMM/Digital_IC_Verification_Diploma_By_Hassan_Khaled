package lion_pkg;

import animal_pkg::*;

class lion extends animal;

	function new(int age);
		super.new(age);
	endfunction : new

	function void make_sound();
		$display("lion says roar");
	endfunction : make_sound

endclass : lion

endpackage