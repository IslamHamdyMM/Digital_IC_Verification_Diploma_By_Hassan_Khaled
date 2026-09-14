package animal_pkg;

virtual class animal;

	int age;

	function new(int a);
		this.age = a;
	endfunction : new

    pure virtual function void make_sound();

endclass

endpackage