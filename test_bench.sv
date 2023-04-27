module top_tb1;

reg clk,rst, enin, enout;
reg  signed [9:0] datain;
wire signed [9:0] dataout;
integer i,j;

reg signed [9:0] matrix [7:0][7:0];       // matrix to read  pixel values from text file and sent it to DUT



reg signed [9:0] matrix_q [7:0][7:0];    // matrix to recive the frequency domain values and store in a text file
integer signed out_file;


always #5 clk = ~clk;
initial clk=0;

top dut(clk,rst, enin, enout,datain,dataout);

initial begin
    rst=1;
    enin=0;
	enout = 0;
    #20;

    rst=0;
    enin=1;
    for (i = 0; i < 8; i = i + 1) begin
    		for (j = 0; j < 8; j = j + 1) begin
     			 datain = matrix[i][j];             // sending each pixel values to DUT in each clock 
                 #10;
  			end
  		end
	#20;
	
    enin = 0;

#400;

	enout =1;
	 for (i = 0; i < 8; i = i + 1) begin
    		for (j = 0; j < 8; j = j + 1) begin
					#10;
     				matrix_q [i][j] = dataout;    // taking frequency domain values from DUT to matrix
                 
  			end
  		end

#40;
		out_file = $fopen("matrix2.txt","w");
		for (i = 0; i < 8; i = i + 1) begin
    			for (j = 0; j < 8; j = j + 1) begin
     			 //datain = i*j;
                 $fwrite(out_file, "%d", matrix_q [i][j]);  // writing matrix value to a text file
  				end
 			$fwrite(out_file, "\n");                         
  		end
	
   $fclose(out_file);

end



reg signed [7:0] value;
integer signed file;


initial begin

	file = $fopen("matrix1.txt", "r");
    
    if (file == 0) begin
      $display("Error opening file '%s'", "matrix1.txt");
      $finish;
    end
    
    for (i = 0; i < 8; i++) begin
      for (j = 0; j < 8; j++) begin
        if (!$fscanf(file, "%d", value)) begin
          $display("Error reading value from file '%s'", "matrix1.txt");
          $finish;
        end
        matrix[i][j] = value;               // reading 64 pixel values from a text file  to 8*8  matrix
      end
    end
    
    $fclose(file);
end


endmodule
