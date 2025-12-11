module LCD_CTRL(clk, reset, cmd, cmd_valid, IROM_Q, IROM_rd, IROM_A, IRAM_valid, IRAM_D, IRAM_A, busy, done);
input clk;
input reset;
input [3:0] cmd;
input cmd_valid;
input [7:0] IROM_Q;
output reg IROM_rd;
output [5:0] IROM_A;
output reg IRAM_valid;
output [7:0] IRAM_D;
output [5:0] IRAM_A;
output reg busy;
output done;

integer i;


parameter [1:0] INPUT=2'd0,CMD=2'd1,CAL=2'd2,OUTPUT=2'd3;
reg [1:0] cs,ns;
reg [3:0] cmd_reg;
reg [7:0] image_data [63:0];
reg [2:0] x_pos,y_pos,x_cal,y_cal;
reg in_valid,in_done,out_done;
wire [5:0] op4 = {y_cal,x_cal};
wire [5:0] op1 = op4 - 9;
wire [5:0] op2 = op4 - 8;
wire [5:0] op3 = op4 - 1;
wire [9:0] sum = (image_data[op1] + image_data[op2]) + (image_data[op3] + image_data[op4]);
reg [5:0] op_max,op_min;
assign IROM_A = {y_pos,x_pos};
assign IRAM_A = (cs == OUTPUT)?{y_pos,x_pos}:0;
assign IRAM_D = image_data[IROM_A];
assign done = out_done;


always@(*)
begin
    if(image_data[op1] >= image_data[op2] && image_data[op1] >= image_data[op3] && image_data[op1] >= image_data[op4]) op_max = op1;
    else if(image_data[op2] >= image_data[op1] && image_data[op2] >= image_data[op3] && image_data[op2] >= image_data[op4]) op_max = op2;
    else if(image_data[op3] >= image_data[op1] && image_data[op3] >= image_data[op2] && image_data[op3] >= image_data[op4]) op_max = op3;
    else op_max = op4;
end

always@(*)
begin
    if(image_data[op1] <= image_data[op2] && image_data[op1] <= image_data[op3] && image_data[op1] <= image_data[op4]) op_min = op1;
    else if(image_data[op2] <= image_data[op1] && image_data[op2] <= image_data[op3] && image_data[op2] <= image_data[op4]) op_min = op2;
    else if(image_data[op3] <= image_data[op1] && image_data[op3] <= image_data[op2] && image_data[op3] <= image_data[op4]) op_min = op3;
    else op_min = op4;
end


always@(posedge clk,posedge reset)
begin
    if(reset) begin
        x_cal<=4;
        y_cal<=4;
    end
    else if(cs == CAL) begin
        case(cmd_reg)
            1:y_cal<=(y_cal == 1)?1:y_cal - 1;
            2:y_cal<=(y_cal == 7)?7:y_cal + 1;    
            3:x_cal<=(x_cal == 1)?1:x_cal - 1;    
            4:x_cal<=(x_cal == 7)?7:x_cal + 1;   
        endcase
    end
end


always@(posedge clk,posedge reset)
begin
    if(reset) begin
        x_pos<=0;
        y_pos<=0;
    end
    else if(in_valid && (in_done == 0)) begin
        x_pos<=x_pos + 1;
        y_pos<=(x_pos == 3'd7)?y_pos+1:y_pos;
    end
    else if(cs == OUTPUT && busy) begin
        x_pos<=x_pos + 1;
        y_pos<=(x_pos == 3'd7)?y_pos+1:y_pos;
    end
end

always@(posedge clk,posedge reset)
begin
    if(reset) cs<=INPUT;
    else cs<=ns;
end

always@(*)
begin
    case(cs)
        INPUT:ns=(in_done)?CMD:INPUT;
        CMD:ns=(cmd_valid)?((cmd == 0)?OUTPUT:CAL):CMD;
        CAL:ns=CMD;
        OUTPUT:ns=(out_done)?INPUT:OUTPUT;
    endcase
end


always@(posedge clk,posedge reset)
begin
    if(reset) begin
        cmd_reg<=0;
        in_valid<=0;
        in_done<=0;
        out_done<=0;
    end
    else begin
        in_valid<=IROM_rd;
        in_done<=(cs == INPUT)?((IROM_A == 6'b111111)?1:in_done):0;
        out_done<=(cs == OUTPUT)?((IRAM_A == 6'b111111)?1:out_done):0; 
        cmd_reg<=(cmd_valid)?cmd:cmd_reg;
    end
end

always@(posedge clk,posedge reset)
begin
    if(reset) begin
        IROM_rd<=1;
        busy<=1;
        IRAM_valid<=0;
    end
    else begin
        case(cs)
            INPUT:begin
                IROM_rd<=(in_done)?0:IROM_rd;
                busy<=(in_done)?0:busy;  
            end
            CMD:busy<=(cmd == 0)?0:1;
            CAL:busy<=0;
            OUTPUT:begin
                busy<=(IRAM_A == 6'b111111)?0:1;
                IRAM_valid<=(IRAM_A == 6'b111111)?0:1;
            end
        endcase
    end
end

always@(posedge clk,posedge reset)
begin
    if(reset) begin
        for(i=0;i<64;i=i+1) image_data[i]<=0;
    end
    else if(cs == INPUT) image_data[IROM_A]<=(in_valid)?IROM_Q:image_data[IROM_A];
    else if(cs == CAL) begin
        case(cmd_reg)
            5:begin
                image_data[op1]<=image_data[op_max];
                image_data[op2]<=image_data[op_max];
                image_data[op3]<=image_data[op_max];
                image_data[op4]<=image_data[op_max];  
            end
            6:begin
                image_data[op1]<=image_data[op_min];
                image_data[op2]<=image_data[op_min];
                image_data[op3]<=image_data[op_min];
                image_data[op4]<=image_data[op_min];  
            end
            7:begin
                image_data[op1]<=sum[9:2];
                image_data[op2]<=sum[9:2];
                image_data[op3]<=sum[9:2];
                image_data[op4]<=sum[9:2];  
            end

            8:begin
                image_data[op1]<=image_data[op2];
                image_data[op2]<=image_data[op4];
                image_data[op3]<=image_data[op1];
                image_data[op4]<=image_data[op3];
            end

            9:begin
                image_data[op1]<=image_data[op3];
                image_data[op2]<=image_data[op1];
                image_data[op3]<=image_data[op4];
                image_data[op4]<=image_data[op2];
            end

            10:begin
                image_data[op1]<=image_data[op3];
                image_data[op2]<=image_data[op4];
                image_data[op3]<=image_data[op1]; 
                image_data[op4]<=image_data[op2]; 
            end

            11:begin
                image_data[op1]<=image_data[op2];
                image_data[op2]<=image_data[op1];
                image_data[op3]<=image_data[op4]; 
                image_data[op4]<=image_data[op3]; 
            end
        endcase
    end
end

endmodule



