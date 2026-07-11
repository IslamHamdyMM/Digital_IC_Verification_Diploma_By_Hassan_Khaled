module union_example;

    typedef union {
        bit[15:0] salary;
        integer id;
    } employee;

    initial begin
        employee emp;
        emp.salary = 'h800;
        $display("salary updated for EMP: %p", emp);
        emp.id = 'd1234;
        $display("ID updated for EMP: %p", emp);
    end
      
endmodule