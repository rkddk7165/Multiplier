
`timescale 1ns/100ps
module tb_multiplier;												//testbench of multiplier
	reg tb_clk, tb_reset_n, tb_op_start, tb_op_clear;		//input and output signal
	reg [63:0] tb_multiplier, tb_multiplicand;
	wire tb_op_done;
	wire [127:0] tb_result;
	wire [63:0] tb_count;
	wire [1:0] tb_state;
	
	always					//generate clock pulse
	begin
		tb_clk=1'b0; #5; tb_clk=1'b1; #5; 	
	end

	//instance of multiplier
	multiplier test_multiplier(.clk(tb_clk), .reset_n(tb_reset_n), .multiplier(tb_multiplier)
									, .multiplicand(tb_multiplicand), .op_start(tb_op_start), .op_clear(tb_op_clear)
									, .op_done(tb_op_done), .result(tb_result), .state(tb_state), .count(tb_count));
	
	initial			//reg values are inputted
	begin				
		tb_reset_n=1'b0; tb_op_start=1'b1; tb_multiplier=3; tb_multiplicand=5; tb_op_clear=0; //6*(-6) execution
#3;	tb_reset_n=1; 
#1000; tb_op_start=0; tb_op_clear=1; 

#20;	tb_op_clear=0; tb_op_start=1; tb_multiplier=-6; tb_multiplicand=6;  
#1000;	tb_op_start=0; tb_op_clear=1;


#20;	tb_op_clear=0; tb_op_start=1; tb_multiplier=64'h1111_1001_1111_1010; tb_multiplicand=64'h1001_0011_1010_1010;
#1000;tb_op_start=0; tb_op_clear=1;

#20;	tb_op_clear=0; tb_op_start=1; tb_multiplier=64'hABCDDDFFDCA; tb_multiplicand=64'd35184372088832;
#1000;tb_op_start=0; tb_op_clear=1;

#20;	tb_op_clear=0; tb_op_start=1; tb_multiplier=64'hBCDDBCDDBCDDBCDD; tb_multiplicand=64'd35184372088832;
#1000; reset_n = 0;

#100; $stop;

	end
		
endmodule