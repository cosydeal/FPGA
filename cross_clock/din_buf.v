`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Engineer		:	ZXK
//	Create Date		:	2024/10/13 16:18
//	Module Name		:	din_buf
//	Target Devices	:	all
//	Tool Versions	:	all
//	Description		:	the module to buffer data by inside clk
//	Revision 		:	Revision 1.00	File	ZXK	2024/09/24	Create        
//						Revision 2.00	File	ZXK	2025/02/26	suitable for all kind of input data        
//////////////////////////////////////////////////////////////////////////////////
module	din_buf(
input	wire			sys_clk	,
input	wire			in_dclk	,
input	wire			i_de	,
input	wire	[7:0]	i_data	,
output	reg				o_de	,
output	reg		[7:0]	o_data
);
//reg define
reg	rd_en_reg;

//wire define
wire			empty		;
wire			rd_en		;
wire	[7:0]	fifo_dout	;

//assign define
assign	rd_en = (empty == 'd0) ? 1'b1: 1'b0;

din_fifo u_din_fifo(
.wr_clk	(in_dclk	),//input	wire			wr_clk
.rd_clk	(sys_clk	),//input	wire			rd_clk
.din	(i_data		),//input	wire	[7:0]	din
.wr_en	(i_de		),//input	wire			wr_en
.rd_en	(rd_en		),//input	wire			rd_en
.dout	(fifo_dout	),//output	wire	[7:0]	dout
.full	(			),//output	wire			full
.empty	(empty		) //output	wire			empty
);

always@(posedge sys_clk) begin
	rd_en_reg <= rd_en;
	o_de <= rd_en_reg;
end
always@(posedge sys_clk) begin
    if(rd_en_reg)
		o_data <= fifo_dout;
    else
		o_data <= 'd0;
end

endmodule