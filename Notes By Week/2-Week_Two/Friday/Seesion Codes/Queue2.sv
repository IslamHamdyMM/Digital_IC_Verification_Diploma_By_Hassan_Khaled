module Queue2;

int j = 1,
    q2[$] = {3,4},   //Queue literals do not use '
    q [$] = {0,2,5}; 

    initial begin //using Concatenations

        q = {q[0],j,q[1:$]}; // Equivalent to insert at postion one {0,1,2,5}
        $display("Queue after insert j at postion 1 : %p",q);
        q = {q[0:2],q2,q[3:$]}; // Equivalent to insert q2 inside q {{0,1,2},{3,4},{5}}
        $display("Queue after insert q2 inside q : %p",q);
        q = {q[0],q[2:$]}; // Equivalent to delete elem. #1 {0,2,3,4,5}
        $display("Queue after delete elem. #1 : %p",q);

        // These operations are fast
        q = {6,q}; // Insert q at front {6,0,2,3,4,5}
        $display("Queue after insert 6 at front : %p",q);
        j = q[$]; q = q[0:$-1]; // Equivalent to pop back {6,0,2,3,4}
        $display("Queue after poping back : %p",q);
        q = {q,8}; // Equivalent to insert 8 at back {6,0,2,3,4,8}
        $display("Queue after insert 8 at back : %p", q);
        j = q[0]; q = q[1:$]; // Euivalent to pop front 
        $display("Queue after poping front : %p",q);
        q = {}; // Delete content 
        $display("\nSize of the queue after deletion ==> %0d ",q.size());
    end
endmodule