module Lab2;

string seq_queue[$];

initial begin
    // Requirment One
    seq_queue.push_back("seq3");
    seq_queue.push_back("seq4");
    seq_queue.push_back("seq5");

    $display("Queue after pushing {seq3,seq4,seq5} back : %p",seq_queue);

    // Requirment Two
    seq_queue.push_front("seq2");
    seq_queue.push_front("seq1");

    $display("Queue after pushing {seq2,seq1} front : %p",seq_queue);

    // Requirment Three
    $display("Size of the queue : %0d",seq_queue.size());

    // Requirment Four 
    void'(seq_queue.pop_front()); // Using Casting method
    $display("Queue after poping front : %p",seq_queue);
    void'(seq_queue.pop_back()); // Using Casting method
    $display("Queue after poping back : %p \n",seq_queue);

    // Requirment Five
    $display("Displaying of Queue elements");
    foreach (seq_queue[i]) begin
        $display("\nseq_queue[%0d] = %s",i,seq_queue[i]);
    end

    $display("\n");

    // Requirment Six
    for(int i = 0;i < seq_queue.size() - 1;i++) begin
        seq_queue.delete(i+1);
    end

    $display("Queue after delete odd elements : %p \n",seq_queue);

    // Requirment Seven 
    seq_queue = {};
    $display("Size of Queue after deletion : %0d",seq_queue.size());
end
endmodule