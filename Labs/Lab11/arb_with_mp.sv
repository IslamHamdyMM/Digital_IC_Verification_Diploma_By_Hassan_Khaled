module arb_with_mp(arb_if.TB arbif);
    
    always @(posedge arbif.clk or posedge arbif.rst)
      begin
        if(arbif.rst)
          arbif.gnt <= '0;
        else if
      end
endmodule