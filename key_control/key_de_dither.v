`timescale	10ns/1ps
/////////////////////////////////////////////////////////////////////////////
//Engineer		:	ZXK
//Create Date	:	2024/9/8	10:44:23
//Module Name	:	key_de_dither
//Target Device	:	ZYNQ-7015
//Description	:	eliminate dither of key(single input)
///////////////Revision///////////////
//veison	0.01	created	by	ZXK
/////////////////////////////////////////////////////////////////////////////

module	key_de_dither#(
parameter	clk_fre = 'd50_000_000
)(
input	wire	clk_in		,
input	wire	sys_rst_n	,
input	wire	key			,
output	wire	key_flag
);

//parameter define
localparam	cnt_max = clk_fre / 50		;//wait for 20ms
localparam	cnt_wid = $clog2(cnt_max)	;//calculate cnt_width

//reg define
reg	[cnt_wid:0]	cnt;

//assign define
assign	key_flag == (cnt == cnt_max - 1'b1) ? 1'b1 : 1'b0;

always@(posedge clk_in or negedge sys_rst_n) begin
	if(~sys_rst_n)
		cnt <= 'd0;
	else
		if(key)
			cnt <= 'd0;
		else
			if( cnt == cnt_max && key == 1'b0)
				cnt <= cnt;
			else
				cnt <= cnt + 1'b1;
end

endmodule
