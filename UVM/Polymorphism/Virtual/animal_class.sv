package animal_pkg;

class animal;

	int age;

	function new(int a);
		this.age = a;
	endfunction : new

    virtual function void make_sound();
    	$fatal(1,"generic animals don't make sound");
    endfunction : make_sound

endclass

endpackage