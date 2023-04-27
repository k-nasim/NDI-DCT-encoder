//......................................................................................................//
//......................................................................................................//

module oneD_DCT_tb;
    reg clk,rst;
    reg signed [9:0] x0,x1,x2,x3,x4,x5,x6,x7;
    wire signed [9:0] xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7;
  
always #5 clk = ~ clk;
initial clk = 0;

oneD_DCT uut( clk,rst,
                x0,x1,x2,x3,x4,x5,x6,x7,
                xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7);

initial begin
    rst=1;
    #20;

    rst=0;
    {x0,x1,x2,x3,x4,x5,x6,x7} = {8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7,8'd8};
    #40;

    {x0,x1,x2,x3,x4,x5,x6,x7} = {8'd10,8'd15,8'd20,8'd25,8'd30,8'd35,8'd40,8'd45};
    #40;

    {x0,x1,x2,x3,x4,x5,x6,x7} = {-8'd10,8'd15,-8'd20,8'd25,-8'd30,8'd35,-8'd40,8'd45};
    #40;
end
endmodule
