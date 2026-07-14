    module assoc1;

        byte assoc[byte], idx = 1;

        initial begin
        // Initialize widely scattered values 
            do begin
                assoc[idx] = idx;
                idx = idx << 1; 
            end while (idx != 0);

            $display("step through all index values with foreach");
            foreach (assoc[i]) begin 
                $display("assoc[%h] = %h",i,assoc[i]);
            end

            $display("Step through all index value with functions");
            if (assoc.first(idx)) begin // Get first index
                do
                $display("assoc[%h] = %h",idx,assoc[idx]);
                while (assoc.next(idx)); // Get next index
            end

            // Find and delete the first element
            void '(assoc.first(idx));
            void '(assoc.delete(idx));
            $display("After deletion of the first element ");
            $display("The array now has %0d elements",assoc.num());
        end
    endmodule