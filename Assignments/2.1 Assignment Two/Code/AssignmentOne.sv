module AssignmentOne;

    //=================== Part_A =====================

    logic signed [3:0] a;
    byte unsigned b;
    shortint c; 
    bit [3:0] d;
    real r;
    string myString = "SV Assignment1";

    //=================== Part_B =====================

    //================3===============================

    int OneD_unpacked_array [4:0] = '{1, 2, 3, 4, 5};
    logic [2:0] [1:0] TwoD_packed_array = '{2'b10,2'b10,2'b10};
    byte OneD_unpacked_array_4 [3:0] = '{10, 20, 30, 40};

    //================4===============================

    typedef struct {
        string name;
        int id;
        byte grade;
    } student_t;

    student_t students[0:2];

    //================5===============================

    typedef union {
        int i;
        byte b;
    } data_u;

    data_u data;

    //=================== Part_C =====================

    int dyn_arr[],dyn_copy[];



    initial begin
        $display("=================== Display Part_A ==============");

        a = -3;
        b = 250;
        c = -12345;
        d = 4'b1101;
        r = 3.14159;

        $display("\nValue of a: %0d", a);
        $display("\nValue of b: %0d", b);
        $display("\nValue of c: %0d", c);
        #5;
        $display("\nValue of d: %0b", d);
        #15;
        $display("\nValue of r: %f", r);
        $display("\nString value: %s", myString);

        $display("\n=================== Display Part_B ================");
    
        $display("\n========================= 3 =======================");

        $display("\nOneD_unpacked_array: %p", OneD_unpacked_array);
        $display("\nTwoD_packed_array: %p", TwoD_packed_array);
        $display("\nOneD_unpacked_array_4: %p", OneD_unpacked_array_4);

        $display("\n========================= 4 =======================");

        students[0] = '{name: "Ali",  id: 1, grade: 85};
        students[1] = '{name: "Sara", id: 2, grade: 90};
        students[2] = '{name: "Omar", id: 3, grade: 78};

        for (int i = 0; i < 3; i++) begin
            $display("\nName: %s, ID: %0d, Grade: %0d", students[i].name, students[i].id, students[i].grade);
        end

        $display("\n========================= 5 =======================");

        data.i = 32'h12345678;
        $display("\nData.i: %h, Data.b: %h", data.i, data.b);
        data.i = 8'h12;
        $display("\nData.i: %h, Data.b: %h", data.i, data.b);

        $display("\n=================== Display Part_C ================");
    
        dyn_arr = '{5, 10, 15, 20, 25};
        dyn_copy = dyn_arr;

        $display("\ndyn_arr: %p, dyn_copy: %p", dyn_arr, dyn_copy);

        dyn_arr = new[20](dyn_arr);
        for(int i = 5; i < 20; i++) begin
            dyn_arr[i] = 'hC;
        end

        $display("\ndyn_arr updated: %p", dyn_arr);
        
        for(int i=0; i<dyn_arr.size(); i++) begin
            $display("\ndyn_arr[%0d]: %d", i, dyn_arr[i]);
        end

        foreach(dyn_copy[i]) begin
            $display("\ndyn_copy[%0d]: %d", i, dyn_copy[i]);
        end

        dyn_copy.delete();
        $display("\ndyn_copy size after delete: %0d", dyn_copy.size());
        $display("\nAssignment 1 completed successfully.\n");

    end
    
endmodule