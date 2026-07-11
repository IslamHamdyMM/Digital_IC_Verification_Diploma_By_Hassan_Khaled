module Lab3;

    int assoc[string];

    initial begin

        assoc["Alice"]   = 85;
        assoc["Bob"]     = 92;
        assoc["Charlie"] = 78;

        $display("\nAlice Score = %0d",assoc["Alice"]);
        $display("\nBob Score   = %0d",assoc["Bob"]);

        assoc["Bob"] = 95;

        for (int i=0; i<assoc.size; ++i) begin
            $display(assoc.next());
            
        end

    
    end
    
endmodule