package RAM_scoreboard_pkg;
import uvm_pkg::*;
import RAM_seq_item_pkg::*;
`include "uvm_macros.svh"
class RAM_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(RAM_scoreboard)
    uvm_analysis_export #(RAM_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
    RAM_seq_item seq_item_sb;
    int error_count = 0;
    int correct_count = 0;

    function new(string name = "RAM_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            if (seq_item_sb.dout != seq_item_sb.dout_golden || seq_item_sb.tx_valid !== seq_item_sb.tx_valid_golden) begin
                `uvm_error("run_phase", $sformatf("Comparison failed, Transaction received by the DUT:
                 %s While the reference dout: %0d, tx_valid: %0d", 
                         seq_item_sb.convert2string(), seq_item_sb.dout_golden,seq_item_sb.tx_valid_golden))
                error_count++;
            end
            else begin
                `uvm_info("run_phase", $sformatf("Correct RAM dout: %s ", seq_item_sb.convert2string()), UVM_HIGH);
                correct_count++;
            end
        end

    endtask
       function void report_phase(uvm_phase phase);
         super.report_phase(phase);
        `uvm_info("RAM", $sformatf("===== RAM Scoreboard Report =====\nCorrect Results: %0d\nErrors: %0d",
            correct_count, error_count), UVM_MEDIUM);
        endfunction
endclass
endpackage