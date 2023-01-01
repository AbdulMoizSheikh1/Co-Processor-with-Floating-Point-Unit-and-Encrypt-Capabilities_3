module FPU_test( 
	input_a,
        input_b,
        input_a_stb,
        input_b_stb,
        output_z_ack,
        clk,
        rst,
	op_sel,
        output_z,
        output_z_stb,
        input_a_ack,
        input_b_ack
);

input     clk;
input     rst;

input [1:0] op_sel;

input     [31:0] input_a;
input     input_a_stb;
output    reg input_a_ack;

input     [31:0] input_b;
input     input_b_stb;
output    reg input_b_ack;

output    reg [31:0] output_z;
output    reg output_z_stb;
input     output_z_ack;

wire [31:0] z_add,z_mul,z_div;
wire z_stb_a,z_stb_m,z_stb_d;
wire a_ack_a,a_ack_m,a_ack_d;
wire b_ack_a,b_ack_m,b_ack_d;

reg [2:0]rst_arr;

divider_fpu d1(
        .input_a(input_a),
        .input_b(input_b),
        .input_a_stb(input_a_stb),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst_arr[2]),
        .output_z(z_div),
        .output_z_stb(z_stb_d),
        .input_a_ack(a_ack_d),
        .input_b_ack(b_ack_d)
);

multiplier_fpu m1(
        .input_a(input_a),
        .input_b(input_b),
        .input_a_stb(input_a_stb),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst_arr[1]),
        .output_z(z_mul),
        .output_z_stb(z_stb_m),
        .input_a_ack(a_ack_m),
        .input_b_ack(b_ack_m)
);

adder_fpu a1(
        .input_a(input_a),
        .input_b(input_b),
        .input_a_stb(input_a_stb),
        .input_b_stb(input_b_stb),
        .output_z_ack(output_z_ack),
        .clk(clk),
        .rst(rst_arr[0]),
        .output_z(z_add),
        .output_z_stb(z_stb_a),
        .input_a_ack(a_ack_a),
        .input_b_ack(b_ack_a)
);

always @ (posedge clk,posedge rst)
begin

if(rst==1)
begin
rst_arr[2:0]<=3'b111;
output_z<=32'h00000000;
output_z_stb<=0;
input_a_ack<=0;
input_b_ack<=0;
end

else
begin

case (op_sel)

2'b00:begin
rst_arr[2:0]<=3'b111;
output_z<=32'h00000000;
output_z_stb<=0;
input_a_ack<=0;
input_b_ack<=0;
end

2'b01:begin
rst_arr[2:0]<=110;
output_z<=z_add;
output_z_stb<=z_stb_a;
input_a_ack<=a_ack_a;
input_b_ack<=b_ack_a;
end

2'b10:begin
rst_arr[2:0]<=101;
output_z<=z_mul;
output_z_stb<=z_stb_m;
input_a_ack<=a_ack_m;
input_b_ack<=b_ack_m;
end

2'b11:begin
rst_arr[2:0]<=011;
output_z<=z_div;
output_z_stb<=z_stb_d;
input_a_ack<=a_ack_d;
input_b_ack<=b_ack_d;
end

endcase

end

end

endmodule
