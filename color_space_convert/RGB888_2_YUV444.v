`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Engineer		:	ZXK
//	Create Date		:	2024/10/13 16:18
//	Module Name		:	din_buf
//	Target Devices	:	all
//	Tool Versions	:	all
//	Description		:	the convert module for RGB888 to YUV444
//	Revision		:	Revision 1.00	File	ZXK	2025/02/24	Create        
//////////////////////////////////////////////////////////////////////////////////
module	RGB888_2_YUV444(
input	wire			p_clk		,
input	wire			sys_rst_n	,
input	wire	[23:0]	i_data		,
input	wire			i_de		,
output	wire	[23:0]	o_data		,
output	reg				o_de
);

//parameter define
localparam	YR_coe = 6'b010011;
localparam	YG_coe = 6'b100101;
localparam	YB_coe = 6'b000111;
localparam	U_coe = 6'b011111;
localparam	V_coe = 6'b111000;

//reg define
reg	[23:0]	data_reg[6:0];
reg	[7:0]	Y_reg[7:0];
reg	[7:0]	U_reg;
reg	[7:0]	V_reg;

//wire define
wire	[13:0]	R_process;
wire	[13:0]	G_process;
wire	[13:0]	B_process;
wire			R_process_en;
wire			G_process_en;
wire			B_process_en;
wire	[7:0]	Y;
wire	[13:0]	U;
wire	[13:0]	V;

//assign define
assign	Y = R_process[13:6] + G_process[13:6] + B_process[13:6];
assign	o_data = {Y_reg[7][7:0],U_reg,V_reg};

mul#(
.da_wid	('d8),
.db_wid	('d6),
.a_dec	('d0),
.b_dec	('d6)
)	u_mul_0(
.sys_clk	(p_clk			),//input	wire	
.sys_rst_n	(sys_rst_n		),//input	wire	
.mul_en		(i_de			),//input	wire	
.a			(i_data[23:16]	),//input	wire	[da_wid - 1'b1:0]
.b			(YR_coe			),//input	wire	[db_wid - 1'b1:0]
.dout_en	(R_process_en	),//output	reg		
.mul_out	(R_process		) //output	reg		[da_wid + db_wid - 1'b1:0]
);

mul#(
.da_wid	('d8),
.db_wid	('d6),
.a_dec	('d0),
.b_dec	('d6)
)	u_mul_1(
.sys_clk	(p_clk			),//input	wire	
.sys_rst_n	(sys_rst_n		),//input	wire	
.mul_en		(i_de			),//input	wire	
.a			(i_data[15:8]	),//input	wire	[da_wid - 1'b1:0]
.b			(YG_coe			),//input	wire	[db_wid - 1'b1:0]
.dout_en	(G_process_en	),//output	reg		
.mul_out	(G_process		) //output	reg		[da_wid + db_wid - 1'b1:0]
);

mul#(
.da_wid	('d8),
.db_wid	('d6),
.a_dec	('d0),
.b_dec	('d6)
)	u_mul_2(
.sys_clk	(p_clk			),//input	wire	
.sys_rst_n	(sys_rst_n		),//input	wire	
.mul_en		(i_de			),//input	wire	
.a			(i_data[7:0]	),//input	wire	[da_wid - 1'b1:0]
.b			(YB_coe			),//input	wire	[db_wid - 1'b1:0]
.dout_en	(B_process_en	),//output	reg		
.mul_out	(B_process		) //output	reg		[da_wid + db_wid - 1'b1:0]
);

integer i;
always@(posedge p_clk or negedge sys_rst_n) begin
	if(~sys_rst_n) begin
		for(i = 'd0;i <'d7;i = i + 1'b1) begin
			data_reg[i] <= 'd0;
		end
	end
	else begin
		data_reg[0] <= i_data;
		for(i = 'd1;i <'d7;i = i + 1'b1) begin
			data_reg[i] <= data_reg[i - 1'b1];
		end
	end
end

mul#(
.da_wid	('d8),
.db_wid	('d6),
.a_dec	('d0),
.b_dec	('d6)
)	u_mul_3(
.sys_clk	(p_clk					),//input	wire	
.sys_rst_n	(sys_rst_n				),//input	wire	
.mul_en		(B_process_en			),//input	wire	
.a			(data_reg[6][7:0] - Y	),//input	wire	[da_wid - 1'b1:0]
.b			(U_coe					),//input	wire	[db_wid - 1'b1:0]
.dout_en	(U_en					),//output	reg		
.mul_out	(U						) //output	reg		[da_wid + db_wid - 1'b1:0]
);

mul#(
.da_wid	('d8),
.db_wid	('d6),
.a_dec	('d0),
.b_dec	('d6)
)	u_mul_3(
.sys_clk	(p_clk					),//input	wire	
.sys_rst_n	(sys_rst_n				),//input	wire	
.mul_en		(R_process_en			),//input	wire	
.a			(data_reg[6][23:16] - Y	),//input	wire	[da_wid - 1'b1:0]
.b			(V_coe					),//input	wire	[db_wid - 1'b1:0]
.dout_en	(V_en					),//output	reg		
.mul_out	(V						) //output	reg		[da_wid + db_wid - 1'b1:0]
);

integer j;
always@(posedge p_clk or negedge sys_rst_n) begin
	if(~sys_rst_n) begin
		for(j = 'd0;j <'d8;j = j + 1'b1) begin
			Y_reg[j] <= 'd0;
		end
	end
	else begin
		Y_reg[0] <= Y;
		for(j = 'd1;j <'d8;j = j + 1'b1) begin
			Y_reg[j] <= Y_reg[j - 1'b1];
		end
	end
end

always@(posedge p_clk) begin
	if(U[13:5] + 'd128 > 'd255)
		U_reg <= 'd255;
	else
		U_reg <= U[13:5] + 'd128;
end

always@(posedge p_clk) begin
	if(V[13:5] + 'd128 > 'd255)
		V_reg <= 'd255;
	else
		V_reg <= V[13:5] + 'd128;
end

always@(posedge p_clk) begin
	o_de <= V_en;
end

endmodule