module Wildcard_array_example;

    // This is a wildcard associative array
    // The key type is not explicitly defined, it can be any integral type
    // or a string, which lead to ambiguity

    int wild_array[*];

    initial begin
        // store some values with different key types
        wild_array[10]       = 100; // int key
        wild_array[3.14]     = 200; // real key (which will be truncated to an integer)
        wild_array[16'hff00] = 300; // bit vector key
        wild_array["my_key"] = 400; // string key
    end
endmodule