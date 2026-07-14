module Lab3;

    int assoc[string];
    string idx;

    initial begin

        // ============== Requirment Two ================ 
        assoc["Alice"]   = 85;
        assoc["Bob"]     = 92;
        assoc["Charlie"] = 78;

        $display("============== Requirment Three ================"); 
        $display("Alice's Score is : %0d",assoc["Alice"]);
        $display("Bob's Score is   : %0d",assoc["Bob"]);

        $display("============== Requirment Four ================"); 
        assoc["Bob"]     = 95;
        $display("Bob's Score after Updating is   : %0d",assoc["Bob"]);

        $display("============== Requirment Five ================"); 
        foreach (assoc[i]) begin
            $display("assoc['%s'] = %0d",i,assoc[i]);
        end

        $display("============== Requirment Six ================"); 
        if (assoc.first(idx)) begin
          do
            $display("assoc['%s'] = %0d",idx,assoc[idx]);
          while (assoc.next(idx));
        end

        $display("============== Requirment Seven ================"); 
        if(assoc.exists("Diana")) begin
            $display("========> Diana Key exists <========");        
        end
        else begin
            $display("========> Diana Key does not exist <========");        
        end

        $display("============== Requirment Eight ================"); 
        void '(assoc.delete("Charlie"));
        if (assoc.exists("Charlie")) begin
            $display("========> Charlie key Exists <========");        
        end
        else begin
            $display("========> Charlie Key Deleted successfully <========");        
        end

        $display("============== Requirment nine ================"); 
        assoc.delete();
        $display("Size of the associative array after deletion is : %0d",assoc.size());

    end
endmodule