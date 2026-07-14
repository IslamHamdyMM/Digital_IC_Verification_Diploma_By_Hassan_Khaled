module Assoc2;

    int switch[string],min_address,max_address,i,file;

    initial begin
        string s;
        file = $fopen("switch.txt","r");
        while (! $feof(file)) begin
            $fscanf(file,"%d %s",i,s);
            switch[s] = i;
        end
        $fclose(file);

        // Get the min address
        // If string not found, use default value of 0 for int array
        min_address = switch["min_address"];

        // Get the max address
        // Use 1000 if max_address does not exist
        if (switch.exists("max_address")) begin
            max_address = switch["max_address"];
        end
        else begin
            max_address = 1000;
        end

        // Print all switches
        foreach (switch[s]) begin
            $display("switch['%s'] = %0d",s,switch[s]);
        end
    end
endmodule