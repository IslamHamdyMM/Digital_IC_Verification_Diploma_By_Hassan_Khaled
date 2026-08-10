module Array_Method3;
    int d[] = '{9,1,8,3,4,4}, tq[$];

    initial begin
        // Find all elemets greater than 3
        tq = d.find with(item>3);   // {9,8,4,4}

        // Equivalent code
        tq.delete();

        foreach(d[i]) begin
            if(d[i] > 3) begin
                tq.push_back(d[i]);
            end
        end

        tq = d.find_index with(item > 3);   // {0,2,4,5}
        $display("Indsies of elements greater than 3 : %p",tq);
        tq = d.find_first with(item > 99); // {} - none found (find first element greater than 99)
        if(tq.size() == 0) begin
            $display("There is no elements greater than 99");
        end

        tq = d.find_first_index with(item == 8);    // {2} d[2] = 8
        $display("First index with item == 8 : %0d",tq);
        tq = d.find_last with(item == 4);   // {4}
        $display("Last with item == 4 : %0d",tq);
        tq = d.find_last_index with(item == 4);     // {5} d[5] = 4
        $display("Last with item == 4 : %0d",tq);
        tq = d.find_first with(item == 4);
        $display("First with item == 4 {Method 1} : %0d",tq);
        tq = d.find_first() with(item == 4);
        $display("First with item == 4 {Method 2} : %0d",tq);
        tq = d.find_first(item) with(item == 4);
        $display("First with item == 4 {Method 3} : %0d",tq);
        tq = d.find_first(x) with(x == 4);
        $display("First with item == 4 {Method 4} : %0d",tq);
    end

endmodule