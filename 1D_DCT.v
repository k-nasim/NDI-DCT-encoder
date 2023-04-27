
//......................................................................................................//
// 1d DCT type 2 algorithm
//......................................................................................................//

module oneD_DCT( input clk,rst,
               input signed [9:0] x0,x1,x2,x3,x4,x5,x6,x7,
               output reg signed [9:0] xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7);


// taking 8 10bit pixel and converts it into 8 10bit frequency domain 

reg signed [9:0] a0,a1,a2,a3,a4,a5,a6,a7;

// to impliment butterfly diagram
wire signed [9:0] b0,b1,b2,b3,b4,b5,b6,b7;
wire signed [9:0] c0,c1,c2,c3,c4,c5,c6,c7;
wire signed [9:0] d0,d1,d2,d3,d4,d5,d6,d7,d8;
wire signed [9:0] e0,e1,e2,e3,e4,e5,e6,e7,e8;
wire signed [9:0] f0,f1,f2,f3,f4,f5,f6,f7;
wire signed [9:0] s0,s1,s2,s3,s4,s5,s6,s7;

//wire signed [17:0] e2t,e3t,e4t,e6t,e7t;
				 

//localparam  [7:0] m1 =8'b10110101 ,
       //    		m2 =8'b01100001 ,
   //       		m3 =8'b10001010 ;
//
//localparam  [8:0] m4 =9'b101001110 ;




localparam  signed [9:0] m1 =10'b0010110101 ,   //  00.70701 reprecented as in binary 00.10110101 
           		m2 =10'b0001100001 ,            //  00.38268 reprecented as in binary 00.01100001
          		m3 =10'b0010001010 ;            //  00.54119 reprecented as in binary 00.10001010

localparam signed [9:0] m4 =10'b0101001110 ;    //  01.3065 reprecented as in binary  01.01001110 



always@(posedge clk)
begin
    if(rst)
        begin
            a0 <= 0;
            a1 <= 0;
            a2 <= 0;
            a3 <= 0;
            a4 <= 0;
            a5 <= 0;
            a6 <= 0;
            a7 <= 0;
        
            xo0 <= 'bz;
            xo1 <= 'bz;
            xo2 <= 'bz;
            xo3 <= 'bz;
            xo4 <= 'bz;
            xo5 <= 'bz;
            xo6 <= 'bz;
            xo7 <= 'bz;

        end
    else 
	begin
            a0 <= x0;
            a1 <= x1;
            a2 <= x2;
            a3 <= x3;
            a4 <= x4;
            a5 <= x5;
            a6 <= x6;
            a7 <= x7;

            xo0 <= s0;
            xo1 <= s1;
            xo2 <= s2;
            xo3 <= s3;
            xo4 <= s4;
            xo5 <= s5;
            xo6 <= s6;
            xo7 <= s7;

            end

end

assign b0 = a0 + a7;
assign b1 = a1 + a6;
assign b2 = a2 - a4;
assign b3 = a1 - a6;
assign b4 = a2 + a5;
assign b5 = a3 + a4;
assign b6 = a2 - a5;
assign b7 = a0 - a7;

assign c0 = b0 + b5;
assign c1 = b1 - b4;
assign c2 = b2 + b6;
assign c3 = b1 + b4;
assign c4 = b0 - b5;
assign c5 = b3 + b7;
assign c6 = b3 + b6;
assign c7 = b7;

assign d0 = c0 + c3;
assign d1 = c0 - c3;
assign d2 = c2;
assign d3 = c1 + c4;
assign d4 = c2 - c5;
assign d5 = c4;
assign d6 = c5;
assign d7 = c6;
assign d8 = c7;

assign e0 = d0;
assign e1 = d1;
assign e2 = (m3 * d2)/256;   // instead of shifting by 8 we are dividing by 256 
assign e3 = (m1 * d7)/256;   // to remove fractional part
assign e4 = (m4 * d6)/256;
assign e5 = d5;
assign e6 = (m1 * d3)/256;
assign e7 = (m2 * d4)/256;
assign e8 = d8;

//assign e2 = e2t/256;
//assign e3 = e3t>>8;
//assign e4 = e4t>>8;
//assign e6 = e6t>>8;
//assign e7 = e7t>>8;
 

assign f0 = e0;
assign f1 = e1;
assign f2 = e5 + e6;
assign f3 = e5 - e6;
assign f4 = e3 + e8;
assign f5 = e8 - e3;
assign f6 = e2 + e7;
assign f7 = e4 + e7;

assign s0 = f0;
assign s1 = f4 + f7;
assign s2 = f2;
assign s3 = f5 - f6;
assign s4 = f1;
assign s5 = f5 + f6;
assign s6 = f3;
assign s7 = f4 - f7;

   
endmodule
