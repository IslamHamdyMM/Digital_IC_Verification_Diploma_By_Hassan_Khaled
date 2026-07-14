module Queue1;

    int j = 1,
        q2[$] = {2,3},
        q [$] = {0,2,3};

    initial begin
        q.insert(1,j); // {0,1,2,3} Insert j before ele #1
        $display("Queue after insert j at location 1 : %p",q);
        q.delete(1);  //  {0,2,3} Delete element #1
        $display("Queue after delete (1) : %p",q);

        // These operations are fast

        q.push_front(6); // {6,0,2,3} Insert at front
        $display("Queue after pushing 6 at the front side : %p",q);
        j = q.pop_back; //{6,0,2}  j = 3 ,return 3 to j
        $display("Queue after poping back to j : %p", q);
        q.push_back(8); // {6,0,2,8} Insert at back
        $display("Queue after pushing 8 at the back side : %p", q);
        j = q.pop_front; // {0,2,8} j = 6,return 6 to j
        $display("Queue after poping front to j : %p", q);

        // printing the entire queue 
        $display("\n Printing the entire queue");
        foreach(q[i]) begin
            $display(q[i]);
        end
        
        // Delete queue
        q.delete(); // or use q = {};

    end


endmodule