class MyCounter;

    string name;
    int count;
    static int total_count = 0;

    function new(string name);
        this.name = name;
        count = 0;
    endfunction

    function void increment();
        count = count + 1;
        total_count = total_count + 1;
    endfunction

    function display();
        $display("Current Counter Name is : %s", name);
        $display("Current Counter Count is :  %0d", count);
    endfunction

    static function void display_total();
        $display("Total_Count Shared = %0d", total_count);
    endfunction

endclass

module Lab5;

    MyCounter c1,c2;

    initial begin

        $display("==================> Starting Lab5 <===================");

        c1 = new("Count1");
        c1.increment();
        c1.display();
        c1.display_total();

        c2 = new("Count2");
        c2.increment();
        c2.display();
        c2.display_total();

        $display("========> This Lab was Done {Alhmdu lillah} <==========");
    end

endmodule



