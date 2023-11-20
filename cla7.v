module cla7(a, b, ci, s, co);			//module of cla6

input [6:0] a, b;							//6-bit two input datas
input ci;									//input port carry in
output [6:0] s;							//6-bit output data
output co;									//output port carry out

wire w1, w2, w3;						//carry wire between fa and fa or between fa and cla

fa fa_0(.a(a[6]),.b(b[6]),.ci(w1),.s(s[6]),.co(co));		
fa fa_1(.a(a[5]),.b(b[5]),.ci(w2),.s(s[5]),.co(w1));							//upper 2-bit is calculated by fa
fa fa_2(.a(a[4]),.b(b[4]),.ci(w3),.s(s[4]),.co(w2));						//
cla4 U2_cla4(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(w3));		//down 4-bit is calculated by cla4

endmodule	