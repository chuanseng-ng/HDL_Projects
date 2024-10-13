class rd_wr_cycle_rand_gen;
    rand bit trans_read;
    rand bit trans_write;

    int rd_toggle_count;
    int wr_toggle_count;

    // Constructor
    function new();
        rd_toggle_count = 0;
        wr_toggle_count = 0;
    endfunction

    // Constraint to toggle trans_read/trans_write
    constraint toggle_constraint_c {
        // Allow toggling 16 times before forcing 0
        rd_toggle_count == 16 -> (trans_read == 0);
        wr_toggle_count == 16 -> (trans_write == 0);
    }

    // Method to toggle signals
    function void toggle_signals();
        for (int i = 0; i < 16; i++) begin
            trans_read  = $urandom_range(0, 1); // Randomly set trans_read
            trans_write = $urandom_range(0, 1); // Randomly set trans_write

            if (trans_read == 1) begin
                rd_toggle_count++;
            end
            if (trans_write == 1) begin
                wr_toggle_count++;
            end
        end
        // Force trans_read/trans_write = 0
        trans_read  = 0;
        trans_write = 0;
    endfunction
endclass
