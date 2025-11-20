`include "synch_fifo.v"
module top;
parameter DEPTH=16;
parameter DATA_WIDTH=08;
parameter PTR_WIDTH=$clog2(DEPTH);
reg clk_i,rst_i, wr_en_i, rd_en_i;
    reg [DATA_WIDTH-1:0]wdata_i;
    wire [DATA_WIDTH-1:0]rdata_o;
    wire full_o, overflow_o, empty_o, underflow_o;
	integer i;
	reg [30*8:0]testname;
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
		$value$plusargs("testname=%0s",testname);
		$display("-->passing testcase name:-|%0s|",testname);
		case(testname)
			"test_full":begin
				write_fifo(0,DEPTH);
			end
			"test_empty":begin
				write_fifo(0,DEPTH);
				read_fifo(0,DEPTH);
			end
			"test_overflow":begin
				write_fifo(0,DEPTH+5);
			end
			"test_underflow":begin
				write_fifo(0,DEPTH);
				read_fifo(0,DEPTH+3);
			end
			"test_over_underflow":begin
				write_fifo(0,DEPTH);
				read_fifo(0,DEPTH+3);
			end
		endcase
		if(full_o==1)$display("\t-->FIFO is in full_condition do not write any data in the FIFO");
		if(overflow_o==1)$display("\t-->FIFO is in overflow_condition do not write any data in the FIFO");
		if(empty_o==1)$display("\t-->FIFO is in empty_condition do not read any data in the FIFO");
		if(underflow_o==1)$display("\t-->FIFO is in underflow_condition do not read the data from the FIFO");
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
	task write_fifo(input integer start_loc,end_loc);
		begin
			for(i=start_loc;i<end_loc;i=i+1)begin
				@(posedge clk_i);
				wr_en_i=1;
				wdata_i=$random;
			end
				@(posedge clk_i);
				wr_en_i=0;
				wdata_i=0;
			end
	endtask
	task read_fifo(input integer start_loc,end_loc);
		begin
			for(i=start_loc;i<end_loc;i=i+1)begin
				@(posedge clk_i);
				rd_en_i=1;
			end
				@(posedge clk_i);
				rd_en_i=0;
			end
	endtask
endmodule




