class fifo_mem_scoreboard extends uvm_component;
    // Scoreboard ports
    uvm_analysis_port #(fifo_transaction) ap;

    // FIFO state
    bit [31:0] expected_fifo [15:0]; // Array to hold expected data
    bit [31:0] actual_fifo   [15:0]; // Array to hold actual data

    bit [31:0] expected_data;
    bit [31:0] actual_data;

    // Pointers
    int wr_idx;
    int rd_idx;
    int expected_wr_idx;
    int expected_rd_idx;

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Initialize indices
        wr_idx = 0;
        rd_idx = 0;

        expected_wr_idx = 0;
        expected_rd_idx = 0;
    endfunction

    task compare_fifo();
        // Compare actual FIFO output with expected output
        if (expected_data !== actual_data) begin
            `uvm_error("SCOREBOARD", $sformatf("Data Mismatch: expected %0d, got %0d", expected_data, actual_data));
        end
    endtask

    task run_phase(uvm_phase phase);
        fifo_transaction tr;
        forever begin
            ap.get_next_item(tr);

            if (tr.trans_write) begin
                expected_fifo[expected_wr_idx] = tr.data;
                expected_wr_idx = (expected_wr_idx + 1) % 16;
            end

            if (tr.trans_read) begin
                actual_data = tr.data;
                comapre_fifo();
                expected_data = expected_fifo[expected_rd_idx];
                expected_rd_idx = (expected_rd_idx + 1) % 16;
            end
        end
    endtask
endclass
