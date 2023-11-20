module multiplier(clk, reset_n, multiplier, multiplicand, op_start, op_clear, op_done, result, state, r_multiplier, count );

  input clk, reset_n;
  input op_start, op_clear;
  
  input [63:0] multiplier, multiplicand;
  
  output reg op_done;
  output [127:0] result;

  output reg[1:0] state;
  reg[1:0] next_state;
  
  reg signed [127:0] result;
  reg [127:0] next_result;
  
  output reg[63:0] count;
  reg[63:0] next_count;
  
  output reg [64:0] r_multiplier;
  reg [64:0] next_r_multiplier;
  
  
  reg [63:0] r_multiplicand;
  
  wire w0;

  parameter IDLE = 2'b00;
  parameter MULTIPLYING = 2'b01;
  parameter DONE = 2'b10;


	always @ (r_multiplicand, multiplicand, r_multiplier) begin
	if(r_multiplier[1] == 1'b1 && r_multiplier[0] == 1'b0) begin
	r_multiplicand = ~(multiplicand);
	end
	
	else if(r_multiplier[1] == 1'b0 && r_multiplier[0] == 1'b1) begin
	r_multiplicand = multiplicand;
	end
	
	else if(r_multiplier[1] == 1'b0 && r_multiplier[0] == 1'b0) begin
	r_multiplicand = 64'b0;
	end
	
	else if(r_multiplier[1] == 1'b1 && r_multiplier[0] == 1'b1) begin
	r_multiplicand = 64'b0;
	end
	
	
	end
	
	//assign wire for ci of cla64 instance (if negative)
  assign w0 = (r_multiplier[1] == 1'b1 && r_multiplier[0] == 1'b0);

  
  wire [127:0] w_result;

  assign w_result[63:0] = result[63:0];


  cla64 U0_cla64(.a(r_multiplicand[63:0]), .b(result[127:64]), .ci(w0), .s(w_result[127:64]), .co());

	

	
  always @(posedge clk or negedge reset_n)
    if (reset_n == 0) begin
      state <= IDLE;
      result <= 128'b0;
      count <= 64'h8000_0000_0000_0000;
      r_multiplier <= 64'b0;
    end
	 
    else begin
      state <= next_state;
      result <= next_result;
      count <= next_count;
      r_multiplier <= next_r_multiplier;
    end

	 
	 //next state logic
  always @(op_start, op_clear, op_done, state)
    case (state)
      IDLE :
			if (op_start == 1'b1)
				next_state = MULTIPLYING; 
				
			else
				next_state = IDLE;
			
      MULTIPLYING :
			if (op_clear == 1'b1) 
				next_state = IDLE; 
				
			else if (op_done == 1'b1) 
				next_state = DONE; 
				
			else
				next_state = MULTIPLYING;
				
      DONE :
			if (op_clear == 1'b1)
				next_state = IDLE; 
			else 
				next_state = DONE;
				
      default : next_state = 2'bx;
    endcase

	 
	 //next result logic
  always @(r_multiplier, state, count, result, next_result, w_result, multiplier, multiplicand, op_clear)
    case (state)
      IDLE : next_result = 128'b0;
		
		

      MULTIPLYING : 	if (count == 64'b0) next_result = result;
							else
									next_result={w_result[127], w_result[127:1]};
								
							

						
						
				
						
      DONE : next_result = result;
      default : next_result = 128'bx;
    endcase

	 

	 
	 //next count logic
  always @(state, count, next_count, op_clear)
	case(state)
		IDLE : next_count = 64'h8000_0000_0000_0000;
		MULTIPLYING : next_count = {1'b0, count[63:1]};
		
		
		DONE: if (op_clear == 1) next_count = 64'h8000_0000_0000_0000; else next_count = count;
  
  
  endcase
  
  
	 //next r_multiplier logic
  always @(state, r_multiplier, multiplier)
    case (state)
      IDLE : next_r_multiplier = {multiplier[63:0], 1'b0};
		
      MULTIPLYING : next_r_multiplier = {r_multiplier[64], r_multiplier[64:1]}; //right shift 1 bit
		
      DONE : next_r_multiplier = r_multiplier;
      default : next_r_multiplier = 65'bx;
    endcase


  always @(op_clear, count) begin
    if (op_clear == 1) op_done = 0;
    else if (count == 64'b0) op_done = 1;
    else op_done = 0;
	end
	 


endmodule

