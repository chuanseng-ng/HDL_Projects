class fifo_mem_trans extends uvm_transaction;
    //rand bit[31:0] data; // Assuming DATA_WIDTH = 32
    //rand bit trans_read;
    //rand bit trans_write;

    function new(string name = "fifo_transaction", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
