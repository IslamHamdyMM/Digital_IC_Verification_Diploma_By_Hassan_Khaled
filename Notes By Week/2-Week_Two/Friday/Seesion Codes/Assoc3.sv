module assoc3;

    // You can initialize an assoiative array literal with Index:element pairs
    int power_of_2[int] = '{0:1,1:2,2:4};

    initial begin
        for(int i = 3; i<5; i++) begin
            power_of_2[i] = 1 << i;
        end

        $display("%p",power_of_2); //'{0:1,1:2,2:4,3:8,4:16}
    end
endmodule