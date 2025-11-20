`include "asynch_fifo.v"
module top;
parameter DEPTH=16;
parameter DATA_WIDTH=08;
parameter PTR_WIDTH=$clog2(DEPTH);
reg clk_i,rst_i, wr_en_i, rd_en_i;
    reg [DATA_WIDTH-1:0]wdata_i;
    wire [DATA_WIDTH-1:0]rdata_o;
    wire full_o, overflow_o, empty_o, underflow_o;
	integer i;
synch_fifo#(.DEPTH(DEPTH),.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .wr_en_i(wr_en_i),
        .wdata_i(wdata_i),
        .full_o(full_o),
        .overflow_o(overflow_o),
        .rd_en_i(rd_en_i),
        .rdata_o(rdata_o),
        .empty_o(empty_o),
        .underflow_o(underflow_o));
	initial begin
        clk_i= 0;
        forever #5 clk_i = ~clk_i;
    end
	initial begin 
		reset_fifo();
		write_fifo();
		repeat(2)@(posedge clk_i);
		read_fifo();
		#50;
		$finish();
	end
	task reset_fifo();
		begin
			rst_i=1;
			wr_en_i=0;
			rd_en_i=0;
			wdata_i=0;
			repeat(2)@(posedge clk_i);
			rst_i=0;
		end
	endtask
	task write_fifo();
		begin
			for(i=0;i<DEPTH;i=i+1)begin
				@(posedge clk_i);
				wr_en_i=1;
				wdata_i=$random;
			end
				@(posedge clk_i);
				wr_en_i=0;
				wdata_i=0;
		end
	endtask
	task read_fifo();
		begin
			for(i=0;i<DEPTH;i=i+1)begin
				@(posedge clk_i);
				rd_en_i=1;
			end
				@(posedge clk_i);
				rd_en_i=0;
		end
	endtask


endmodule


