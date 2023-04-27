//......................................................................................................//
// 2D DCT (top module)
//......................................................................................................//

// passing pixel values one by one
// wich stores in an 8*8  matrix memory
module top (    input clk,rst, enin, enout,
                input signed [9:0] datain,
                output reg signed [9:0] dataout);

reg signed [9:0] seg [7:0][7:0];  // pixel values 
reg signed [9:0] seg_r [7:0][7:0];  // 1D DCT raw transformed values
reg signed [9:0] seg_c [7:0][7:0];  // (frquency domain) 1D DCT column transformed values after raw
reg signed [9:0] seg_q [7:0][7:0];  // quntised frequency domain values
//reg [7:0] q50 [7:0][7:0];
integer i,j,u,v;



reg signed [9:0] q50 [7:0][7:0] ;  // matrix for 50% quality coefficient to quantize

 //'{
  //  '{99, 103, 100, 112, 98, 95, 92, 72},
 //   '{101, 120, 121, 103, 87, 78, 64, 49},
  //  '{77, 103, 109, 68, 56, 37, 22, 18},
  //  '{62, 80, 87, 51, 29, 22, 17, 14},
  //  '{56, 69, 57, 40, 24, 16, 13, 14},
  //  '{55, 60, 58, 26, 19, 14, 12, 12},
  //  '{61, 51, 40, 24, 16, 10, 11, 16},
  //  '{72, 61, 51, 40, 24, 16, 11, 16}
//};



reg [2:0] k,n;
wire [2:0] l;

reg [1:0] s;

reg [9:0]  x0,x1,x2,x3,x4,x5,x6,x7;
wire [9:0] xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7;


always@( posedge clk)
begin
    if(rst) begin 
		q50 [0][0] <= 8'd16;
 		q50 [0][1] <= 8'd11;
 		q50 [0][2] <= 8'd10;
		q50 [0][3] <= 8'd16;
 		q50 [0][4] <= 8'd24;
 		q50 [0][5] <= 8'd40;
 		q50 [0][6] <= 8'd51;
 		q50 [0][7] <= 8'd61;

 		q50 [1][0] <= 8'd12;
 		q50 [1][1] <= 8'd12;
 		q50 [1][2] <= 8'd14;
 		q50 [1][3] <= 8'd19;
 		q50 [1][4] <= 8'd26;
 		q50 [1][5] <= 8'd58;
		q50 [1][6] <= 8'd60;
 		q50 [1][7] <= 8'd55;

 		q50 [2][0] <= 8'd14;
 		q50 [2][1] <= 8'd13;
 		q50 [2][2] <= 8'd16;
		q50 [2][3] <= 8'd24;
 		q50 [2][4] <= 8'd40;
 		q50 [2][5] <= 8'd57;
 		q50 [2][6] <= 8'd69;
 		q50 [2][7] <= 8'd56;

 		q50 [3][0] <= 8'd14;
 		q50 [3][1] <= 8'd17;
 		q50 [3][2] <= 8'd22;
 		q50 [3][3] <= 8'd29;
 		q50 [3][4] <= 8'd51;
 		q50 [3][5] <= 8'd87;
 		q50 [3][6] <= 8'd80;
 		q50 [3][7] <= 8'd62;

 		q50 [4][0] <= 8'd18;
 		q50 [4][1] <= 8'd22;
 		q50 [4][2] <= 8'd37;
 		q50 [4][3] <= 8'd56;
 		q50 [4][4] <= 8'd68;
 		q50 [4][5] <= 8'd109;
 		q50 [4][6] <= 8'd103;
 		q50 [4][7] <= 8'd77;

 		q50 [5][0] <= 8'd24;
 		q50 [5][1] <= 8'd35;
 		q50 [5][2] <= 8'd55;
 		q50 [5][3] <= 8'd64;
 		q50 [5][4] <= 8'd81;
 		q50 [5][5] <= 8'd104;
 		q50 [5][6] <= 8'd113;
 		q50 [5][7] <= 8'd92;

 		q50 [6][0] <= 8'd49;
 		q50 [6][1] <= 8'd64;
 		q50 [6][2] <= 8'd78;
 		q50 [6][3] <= 8'd87;
	 	q50 [6][4] <= 8'd103;
 		q50 [6][5] <= 8'd121;
		q50 [6][6] <= 8'd120;
 		q50 [6][7] <= 8'd101;

 		q50 [7][0] <= 8'd72;
 		q50 [7][1] <= 8'd92;
 		q50 [7][2] <= 8'd95;
 		q50 [7][3] <= 8'd98;
 		q50 [7][4] <= 8'd112;
 		q50 [7][5] <= 8'd100;
 		q50 [7][6] <= 8'd103;
		q50 [7][7] <= 8'd99;
	end
end


		

always@( posedge clk)
begin
    if(rst) begin
		for (i = 0; i < 8; i = i + 1) begin
    		for (j = 0; j < 8; j = j + 1) begin
     			 seg[i][j] <= 8'd0;
  			end
  		end
    		{i,j,u,v} <= 0;
		dataout <= 'dz;
    end
    else if(enin &&(i<8))
    begin
		seg[i][j] <= datain;
       	
      	if(j==7) begin
            j <= 0;
            i <= i+1;
		end
        else
        	j <= j+1;
    end
	else if(enout&&(u<8))
	begin
		dataout <= seg_q[u][v];
       	
      	if(v==7) begin
            v <= 0;
            u <= u+1;
		end
        else
        	v <= v+1;
	end
end

always @( posedge clk)
begin
	if(rst)
		{k,s} <=0;
    else if(!rst && !enin)
    begin
        if(s<2) begin
                // 1d DCT raw operation 

            {x0,x1,x2,x3,x4,x5,x6,x7} <= {seg[k][0],seg[k][1],seg[k][2],seg[k][3],seg[k][4],seg[k][5],seg[k][6],seg[k][7]};

            {seg_r[l][0],seg_r[l][1],seg_r[l][2],seg_r[l][3],seg_r[l][4],seg_r[l][5],seg_r[l][6],seg_r[l][7]}  <= {xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7};

            k <= k+1;
            if(k==7)
                s <= s+1;
         end
        else begin
           // 1d DCT column operation 

            {x0,x1,x2,x3,x4,x5,x6,x7} <= {seg_r[0][k],seg_r[1][k],seg_r[2][k],seg_r[3][k],seg_r[4][k],seg_r[5][k],seg_r[6][k],seg_r[7][k]};
            {seg_c[0][l],seg_c[1][l],seg_c[2][l],seg_c[3][l],seg_c[4][l],seg_c[5][l],seg_c[6][l],seg_c[7][l]}  <= {xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7};
            k <= k+1;
            if(k==7)
                s <= s+1;
        end
    end
end    



always @( posedge clk)
begin
	if(rst)
		n <=0;
 	else if(!rst && !enin) begin
        if(s<2)
         begin
            // quantization using 50% quality coefficients
            {seg_q[n][0],seg_q[n][1],seg_q[n][2],seg_q[n][3],seg_q[n][4],seg_q[n][5],seg_q[n][6],seg_q[n][7]}
                <= { seg_c[n][0]/q50[n][0],seg_c[n][1]/q50[n][1],seg_c[n][2]/q50[n][2],seg_c[n][3]/q50[n][3],seg_c[n][4]/q50[n][4],seg_c[n][5]/q50[n][5],seg_c[n][6]/q50[n][6],seg_c[n][7]/q50[n][7]};
            n <= n+1;
         end
    end
end 



assign l = k+5;

oneD_DCT r1( clk,rst,
            x0,x1,x2,x3,x4,x5,x6,x7,
            xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7);



// aditional lines to monitor matrix values in transcript window

// integer a,b;
// always @( posedge clk)
// begin
// 	if(s==0 && k==0) begin


//  		$display("\n........................seg");
// 		for (a = 0; a < 8; a = a + 1) begin	
//      		 	$display("\t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d ", seg[a][0],seg[a][1],seg[a][2],seg[a][3],seg[a][4],seg[a][5],seg[a][6],seg[a][7]); 
//   		end



// 		$display("\n........................seg_r");
// 		for (a = 0; a < 8; a = a + 1) begin
//      		 	$display("\t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d ", seg_r[a][0],seg_r[a][1],seg_r[a][2],seg_r[a][3],seg_r[a][4],seg_r[a][5],seg_r[a][6],seg_r[a][7]); 
//   		end
		
// 		$display("\n........................seg_c");
// 		for (a = 0; a < 8; a = a + 1) begin
//      		 	$display("\t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d ", seg_c[a][0],seg_c[a][1],seg_c[a][2],seg_c[a][3],seg_c[a][4],seg_c[a][5],seg_c[a][6],seg_c[a][7]); 
//   		end

		
// 		$display("\n........................q50");
// 		for (a = 0; a < 8; a = a + 1) begin
//      			$display("\t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d ", q50[a][0],q50[a][1],q50[a][2],q50[a][3],q50[a][4],q50[a][5],q50[a][6],q50[a][7]); 
//   		end


// 		$display("\n........................seg_q");
// 		for (a = 0; a < 8; a = a + 1) begin
//      		 	$display("\t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d ", seg_q[a][0],seg_q[a][1],seg_q[a][2],seg_q[a][3],seg_q[a][4],seg_q[a][5],seg_q[a][6],seg_q[a][7]); 
//   		end

// 	end
// 	else 
// 		{a,b} = 0;
// end


endmodule
