`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Engineer		:	ZXK
//	Create Date		:	2024/09/24 14:18
//	Module Name		:	mul
//	Target Devices	:	all
//	Tool Versions	:	all
//	Description		:	the module to process mul
//	Revision		:	Revision 1.00	File	ZXK	2024/09/24	Create        
//						Revision 2.00	File	ZXK	2025/02/26	suitable for all kind of input data        
//////////////////////////////////////////////////////////////////////////////////
module	mul#(
parameter	da_wid = 'd15	,
parameter	db_wid = 'd15	,
parameter	a_dec = 'd4		,
parameter	b_dec = 'd4
)(
input	wire								sys_clk		,
input	wire								sys_rst_n	,
input	wire								mul_en		,
input	wire	[da_wid - 1'b1:0]			a			,
input	wire	[db_wid - 1'b1:0]			b			,
output	reg									dout_en		,
output	reg		[da_wid + db_wid - 1'b1:0]	mul_out
);

reg	[da_wid + db_wid - 1'b1:0]	mul_out_reg[db_wid - 1'b1:0];
reg	[db_wid - 1'b1:0]			b_reg[db_wid - 1'b1:0];
reg	[da_wid - 1'b1:0]			a_reg[db_wid - 1'b1:0];
reg	[db_wid - 1'b1:0]			en_reg;

integer	k;
always@(posedge sys_clk or negedge sys_rst_n) begin
	if(~sys_rst_n)
		for(k = 'd0;k < db_wid;k = k+ 1'b1) begin
			b_reg[k] <= 'd0;
		end
	else begin
		b_reg[0] <= b;
		for(k = 'd1;k < db_wid;k = k + 1'b1) begin
			b_reg[k] <= b_reg[k - 1'b1];
		end
	end
end

integer	p;
always@(posedge sys_clk or negedge sys_rst_n) begin
	if(~sys_rst_n)
		for(p = 'd0;p < db_wid;p = p+ 1'b1) begin
				a_reg[p] <= 'd0;
		end
	else begin
		a_reg[0] <= a;
		for(p = 'd1;p < db_wid;p = p + 1'b1) begin
			a_reg[p] <= a_reg[p - 1'b1];
		end
	end
end

integer	i;
always@(posedge sys_clk or negedge sys_rst_n) begin
	if(~sys_rst_n)
		for(i = 'd0;i < db_wid;i = i+ 1'b1) begin
			mul_out_reg[i] <= 'd0;
		end
	else begin
		if(b[0] == 'd0)
			mul_out_reg[0] <= 'd0;
		else
			mul_out_reg[0] <= a;
		for(i = 'd0;i < db_wid - 1'b1;i = i + 1'b1) begin
			if(b_reg[i][i + 1'b1] == 'd0)
				mul_out_reg[i + 1'b1] <= mul_out_reg[i];
			else
				mul_out_reg[i + 1'b1] <= mul_out_reg[i] + (a_reg[i] << (i + 1'b1));
		end
	end
end

integer	j;
always@(posedge sys_clk or negedge sys_rst_n) begin
	if(~sys_rst_n)
		en_reg <= 'd0;
	else begin
		en_reg[0] <= mul_en;
		for(j = 'd1;j < db_wid;j = j + 1'b1) begin
			en_reg[j] <= en_reg[j - 1'b1];
		end
	end
end

always@(posedge sys_clk) begin
	mul_out <= mul_out_reg[db_wid - 1'b1];
end

always@(posedge sys_clk) begin
	dout_en <= en_reg[db_wid - 1'b1];
end

endmodule