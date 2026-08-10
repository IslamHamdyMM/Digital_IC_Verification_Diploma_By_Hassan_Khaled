// ================== Note ======================
// SystemVerilog would make the calculations with enough precision not to lse any bits.
// But the sum ethod uses the width of the array. So, if you add the values of a single-bit array,
// the result is a single bit

module Array_Methods5;

    bit one[6];     // Array of single bits
    int total;

    initial begin
        foreach(one[i]) begin
            one[i] = i;
        end                  // one[i] gets 0 or 1

        // compute the single-bit sum
        total = one.sum();           // total = 1 = (0+1+0+1+0+1) & 1;
        $dispay("Total sum before casting is : %0d",total);

        // compute with 32-bit signed arithimetic
        total = one.sum() with(int'(item)); // total = 3
        $display("Total sum after casting is : %0d",total);
    end
endmodule




