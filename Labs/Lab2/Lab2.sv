module Lab2;
    
    //======(1)========
    string seq_queue[$];


    initial begin

    $display("========(2)========");
    seq_queue = {seq_queue,"seq3","seq4","seq5"};
    $display("\nStep 2 : %p",seq_queue);

    $display("\n========(3)========");
    seq_queue = {"seq1","seq2",seq_queue};
    $display("\nStep 3 : %p",seq_queue);

    $display("\n========(4)========");
    $display("\nCurrent queue Size is %0d", seq_queue.size());

    $display("\n========(5.1)========");
    $display("\nFront element: %s", seq_queue.pop_front());

    $display("\n========(5.2)========");
    $display("\nLast Element: %s",seq_queue.pop_back());

    $display("\n========(6)========");
    foreach (seq_queue[i]) begin
        $display("seq_queue [%0d] = %s",i, seq_queue[i]); 
    end

    $display("\n========(7)========");
    for(int i = 0; i < seq_queue.size() - 1; i++) begin
       seq_queue.delete(i+1);
    end

    $display("\nCurrent queue elements : %p",seq_queue);

    $display("\n========(8)========");
    seq_queue = {};
    $display("\nCurrent queue Size is %0d", seq_queue.size());

    end

endmodule
