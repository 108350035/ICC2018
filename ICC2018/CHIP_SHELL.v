module CHIP(clk, 
		reset, 
		cmd, 
		cmd_valid, 
             IROM_rd, 
		 IROM_A, 
		IROM_Q, 
             IRAM_valid, 
		IRAM_D, IRAM_A,
		     busy, done);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output IROM_rd;
output [5:0] IROM_A;
output IRAM_valid;
output [7:0] IRAM_D;
output [5:0] IRAM_A;
output busy;
output done;


wire C_clk;
wire C_reset;
wire [3:0] C_cmd;
wire C_cmd_valid;
wire [7:0] C_IROM_Q;
wire  C_IROM_rd;
wire [5:0] C_IROM_A;
wire  C_IRAM_valid;
wire [7:0] C_IRAM_D;
wire [5:0] C_IRAM_A;
wire  C_busy;
wire C_done;




wire BUF_clk;
CLKBUFX20 buf0(.A(C_clk),.Y(BUF_clk));

LCD_CTRL LCD_CTRL(.clk(BUF_clk), .reset(C_reset), 
		     .cmd(C_cmd), .cmd_valid(C_cmd_valid), 
                     .IROM_rd(C_IROM_rd), .IROM_A(C_IROM_A), .IROM_Q(C_IROM_Q), 
                     .IRAM_valid(C_IRAM_valid), .IRAM_D(C_IRAM_D), .IRAM_A(C_IRAM_A),
		     .busy(C_busy), .done(C_done));


// Input Pads
PDUSDGZ I_CLK(.PAD(clk), .C(C_clk));
PDUSDGZ I_RESET(.PAD(reset), .C(C_reset));
PDUSDGZ I_CMD_V  (.PAD(cmd_valid),  .C(C_cmd_valid));
PDUSDGZ I_CMD_0  (.PAD(cmd[0]),  .C(C_cmd[0]));
PDUSDGZ I_CMD_1  (.PAD(cmd[1]),  .C(C_cmd[1]));
PDUSDGZ I_CMD_2  (.PAD(cmd[2]),  .C(C_cmd[2]));
PDUSDGZ I_CMD_3  (.PAD(cmd[3]),  .C(C_cmd[3]));
PDUSDGZ I_ROMQ0  (.PAD(IROM_Q[0]),  .C(C_IROM_Q[0]));
PDUSDGZ I_ROMQ1  (.PAD(IROM_Q[1]),  .C(C_IROM_Q[1]));
PDUSDGZ I_ROMQ2  (.PAD(IROM_Q[2]),  .C(C_IROM_Q[2]));
PDUSDGZ I_ROMQ3  (.PAD(IROM_Q[3]),  .C(C_IROM_Q[3]));
PDUSDGZ I_ROMQ4  (.PAD(IROM_Q[4]),  .C(C_IROM_Q[4]));
PDUSDGZ I_ROMQ5  (.PAD(IROM_Q[5]),  .C(C_IROM_Q[5]));
PDUSDGZ I_ROMQ6  (.PAD(IROM_Q[6]),  .C(C_IROM_Q[6]));
PDUSDGZ I_ROMQ7  (.PAD(IROM_Q[7]),  .C(C_IROM_Q[7]));


// Output Pads
PDD08SDGZ O_BUSY  (.OEN(1'b0), .I(C_busy),  .PAD(busy),  .C());
PDD08SDGZ O_DONE  (.OEN(1'b0), .I(C_done),  .PAD(done),  .C());
PDD08SDGZ O_IRAM_V  (.OEN(1'b0), .I(C_IRAM_valid),  .PAD(IRAM_valid),  .C());
PDD08SDGZ O_IRAMD0  (.OEN(1'b0), .I(C_IRAM_D[0]),  .PAD(IRAM_D[0]),  .C());
PDD08SDGZ O_IRAMD1  (.OEN(1'b0), .I(C_IRAM_D[1]),  .PAD(IRAM_D[1]),  .C());
PDD08SDGZ O_IRAMD2  (.OEN(1'b0), .I(C_IRAM_D[2]),  .PAD(IRAM_D[2]),  .C());
PDD08SDGZ O_IRAMD3  (.OEN(1'b0), .I(C_IRAM_D[3]),  .PAD(IRAM_D[3]),  .C());
PDD08SDGZ O_IRAMD4  (.OEN(1'b0), .I(C_IRAM_D[4]),  .PAD(IRAM_D[4]),  .C());
PDD08SDGZ O_IRAMD5  (.OEN(1'b0), .I(C_IRAM_D[5]),  .PAD(IRAM_D[5]),  .C());
PDD08SDGZ O_IRAMD6  (.OEN(1'b0), .I(C_IRAM_D[6]),  .PAD(IRAM_D[6]),  .C());
PDD08SDGZ O_IRAMD7  (.OEN(1'b0), .I(C_IRAM_D[7]),  .PAD(IRAM_D[7]),  .C());
PDD08SDGZ O_IRAMA0  (.OEN(1'b0), .I(C_IRAM_A[0]),  .PAD(IRAM_A[0]),  .C());
PDD08SDGZ O_IRAMA1  (.OEN(1'b0), .I(C_IRAM_A[1]),  .PAD(IRAM_A[1]),  .C());
PDD08SDGZ O_IRAMA2  (.OEN(1'b0), .I(C_IRAM_A[2]),  .PAD(IRAM_A[2]),  .C());
PDD08SDGZ O_IRAMA3  (.OEN(1'b0), .I(C_IRAM_A[3]),  .PAD(IRAM_A[3]),  .C());
PDD08SDGZ O_IRAMA4  (.OEN(1'b0), .I(C_IRAM_A[4]),  .PAD(IRAM_A[4]),  .C());
PDD08SDGZ O_IRAMA5  (.OEN(1'b0), .I(C_IRAM_A[5]),  .PAD(IRAM_A[5]),  .C());
PDD08SDGZ O_IROMA0  (.OEN(1'b0), .I(C_IROM_A[0]),  .PAD(IROM_A[0]),  .C());
PDD08SDGZ O_IROMA1  (.OEN(1'b0), .I(C_IROM_A[1]),  .PAD(IROM_A[1]),  .C());
PDD08SDGZ O_IROMA2  (.OEN(1'b0), .I(C_IROM_A[2]),  .PAD(IROM_A[2]),  .C());
PDD08SDGZ O_IROMA3  (.OEN(1'b0), .I(C_IROM_A[3]),  .PAD(IROM_A[3]),  .C());
PDD08SDGZ O_IROMA4  (.OEN(1'b0), .I(C_IROM_A[4]),  .PAD(IROM_A[4]),  .C());
PDD08SDGZ O_IROMA5  (.OEN(1'b0), .I(C_IROM_A[5]),  .PAD(IROM_A[5]),  .C());
PDD08SDGZ O_IROMRD  (.OEN(1'b0), .I(C_IROM_rd),  .PAD(IROM_rd),  .C());
// IO power 
PVDD2DGZ VDDP0 ();
PVSS2DGZ GNDP0 ();
PVDD2DGZ VDDP1 ();
PVSS2DGZ GNDP1 ();
PVDD2DGZ VDDP2 ();
PVSS2DGZ GNDP2 ();
PVDD2DGZ VDDP3 ();
PVSS2DGZ GNDP3 ();



// Core power
PVDD1DGZ VDDC0 ();
PVSS1DGZ GNDC0 ();
PVDD1DGZ VDDC1 ();
PVSS1DGZ GNDC1 ();
PVDD1DGZ VDDC2 ();
PVSS1DGZ GNDC2 ();
PVDD1DGZ VDDC3 ();
PVSS1DGZ GNDC3 ();



endmodule

