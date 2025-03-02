`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Engineer		:	ZXK
//	Create Date		:	2025/02/24 11:02
//	Module Name		:	RGB888_2_RGB565
//	Target Devices	:	all
//	Tool Versions	:	all
//	Description		:	the convert module for RGB888 to RGB565
//	Revision		:	Revision 1.00	File	ZXK	2025/02/24	Create        
//////////////////////////////////////////////////////////////////////////////////
module	RGB888_2_RGB565(
input	wire			p_clk	,
input	wire	[23:0]	i_data	,
input	wire			i_de	,
output	wire	[15:0]	o_data	,
output	reg				o_de
);

reg	[4:0]	R5;
reg	[5:0]	G6;
reg	[4:0]	B5;

assign	o_data = {R5,G6,B5};

always@(posedge p_clk) begin
	R5 <= i_data[23:19];
	G6 <= i_data[15:10];
	B5 <= i_data[7:3];
end

always@(posedge p_clk) begin
	o_de <= i_de;
end

endmodule