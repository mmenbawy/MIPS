module ALU(out,zero,operand1,operand2,ALUop,shamt);
output zero;
output [31:0] out;
input[31:0] operand1;
input [31:0] operand2;
input [2:0] ALUop;
input [4:0] shamt;
reg[31:0] out;
reg zero;
always @(operand1 or operand2 or ALUop) begin
	if (((operand1 == operand2) && (ALUop != 3'b111)) || (ALUop == 3'b111 && operand1 != operand2)) 
		begin
		zero <=1'b1; 
		end
	else  
		begin
		zero <=0;
		end
	
end	
	
always @(operand1 or operand2 or ALUop) begin
	case (ALUop)
	3'b000 : out = operand1 + operand2;
	3'b001 : out = operand1 - operand2;
	3'b010 : out = operand2 << shamt;//shift logical left !
	3'b011 : out = operand2 >> shamt;//shift logical right !
	3'b100 : out = operand1 | operand2;
	3'b101 : out = operand1 & operand2;
	3'b110 : out = operand1 < operand2;
	default: out = operand1 + operand2;
	endcase
end
endmodule	