`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Engineer		:	ZXK
//	Create Date		:	2025/02/24 11:02
//	Module Name		:	RGB565_2_RGB888
//	Target Devices	:	all
//	Tool Versions	:	all
//	Description		:	the convert module for RGB565 to RGB888
//	Revision		:	Revision 1.00	File	ZXK	2025/02/24	Create        
//////////////////////////////////////////////////////////////////////////////////
module        RGB565_2_RGB888(
input	wire	      	p_clk	,
input	wire	[15:0]	i_data	,
input	wire			i_de	,
output	wire	[23:0]	o_data	,
output	reg				o_de
);

reg	[7:0]	R8;
reg	[7:0]	G8;
reg	[7:0]	B8;

assign	o_data = {R8,G8,B8};

always@(posedge p_clk) begin
	R8 <= {i_data[15:11],3'd0};
	G8 <= {i_data[10:5],2'd0};
	B8 <= {i_data[4:0],3'd0};
end

always@(posedge p_clk) begin
	o_de <= i_de;
end

endmodule