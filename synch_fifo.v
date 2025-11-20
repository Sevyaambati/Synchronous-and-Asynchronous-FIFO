//Implementation of synch_fifo:-

module synch_fifo(clk_i,rst_i,wr_en_i,wdata_i,full_o,overflow_o,rd_en_i,rdata_o,empty_o,underflow_o);
//Declare the parameters:-
	parameter DEPTH=16;
	parameter DATA_WIDTH=08;
	parameter PTR_WIDTH=$clog2(DEPTH);
//Declare the inputs and outputs:-
	input clk_i,rst_i,wr_en_i,rd_en_i;
	input [DATA_WIDTH-1:0] wdata_i;
	output reg [DATA_WIDTH-1:0] rdata_o;
	output reg full_o,overflow_o,empty_o,underflow_o;
//Memory allocation:-

	reg[DATA_WIDTH-1:0] fifo[DEPTH-1:0];
	integer i;
//Declare the internal signals:-

	reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr;
	reg wr_tg_f,rd_tg_f;

// implement the functionality of the circuit:-

	always@(posedge clk_i)begin
		if(rst_i==1)begin
			rdata_o=0;
			full_o=0;
			overflow_o=0;
			empty_o=1;
			underflow_o=0;
			wr_ptr=0;
			rd_ptr=0;
			wr_tg_f=0;
			rd_tg_f=0;
			for(i=0;i<DEPTH;i=i+1)begin
				fifo[i]=0;
			end
		end
		else begin
			overflow_o=0;
			underflow_o=0;
			if(wr_en_i==1)begin
				if(full_o==1)begin
				overflow_o=1;
				end
				else begin
					fifo[wr_ptr]=wdata_i;
					if(wr_ptr==DEPTH-1)begin
						wr_tg_f=~wr_tg_f;
					end
					wr_ptr=wr_ptr+1;
				end
			end
		end
		if(rd_en_i==1)begin
			if(empty_o==1)begin
				underflow_o=1;
			end
			else begin
				rdata_o=fifo[rd_ptr];
				if(rd_ptr==DEPTH-1)begin
					rd_tg_f=~rd_tg_f;
				end
				rd_ptr=rd_ptr+1;
			end
		end
	end

	always@(*)begin
	full_o=0;
	empty_o=0;
	if(wr_ptr==rd_ptr && wr_tg_f!=rd_tg_f) full_o=1;
	else if(wr_ptr==rd_ptr && wr_tg_f==rd_tg_f) empty_o=1;
	end
endmodule
