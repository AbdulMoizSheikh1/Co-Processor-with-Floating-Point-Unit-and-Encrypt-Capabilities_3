module final_test (
	/*in,
	//input_a,
        //input_b,
        input_a_stb,
        input_b_stb,
        output_z_ack,
        clk,
        rst,
	op_sel,
        output_z,
        output_z_stb,
        input_a_ack,
        input_b_ack,
        vccd1,
        vssd1*/


`ifdef USE_POWER_PINS
    inout vccd1,	
    inout vssd1,	
`endif

input [31:0] in,

input     clk,
input     rst,

input [1:0] op_sel,


//input     [31:0] input_a;
input     input_a_stb,
output    input_a_ack,


//input     [31:0] input_b;
input     input_b_stb,
output    input_b_ack,

output    [31:0] output_z,
output    output_z_stb,
input     output_z_ack,
);

reg rsta,rstb;
wire rsto;
reg [1:0]inflag;
reg onflag;
reg     [31:0] input_a;
reg     [31:0] input_b;
assign rsto=rstb||rst;
always @ (posedge clk)
begin
rsta<=rst;
rstb<=rsta;
end

always @ (input_a || input_b || rsto)
begin
if(rsto)
inflag=2'b00;
else
inflag=inflag+1;
end

always @ (in || rsto)
begin
if(rsto)
onflag=0;
else
onflag=~onflag;
end

always @ (posedge clk,posedge rsto)
begin
if(rsto)
begin
input_a<=0;
input_b<=0;
end
else
begin
if(inflag[0] && !onflag)
input_b<=in;
if(!inflag[0] && onflag)
input_a<=in;
end
end


FPU_test f1(
        .input_a(input_a),
        .input_b(input_b),
        .input_a_stb(input_a_stb),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rsto),
	.op_sel(op_sel),
        .output_z(output_z),
        .output_z_stb(output_z_stb),
        .input_a_ack(input_a_ack),
        .input_b_ack(input_b_ack)
);


endmodule
