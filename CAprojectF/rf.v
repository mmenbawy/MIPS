module registerFile (clk,rs,rt,rd,data1,data2,writeData,regWrite);
input clk;
input [4:0] rs,rt,rd;
input [31:0] writeData;
input regWrite;

output [31:0] data1, data2;

reg [31:0] data1, data2;

reg [31:0] registers[31:0];

always @ (rs or rt)
begin
data1 <= (rs==5'b0)?32'b0:registers[rs];
data2 <= (rt==5'b0)?32'b0: registers[rt];
end


always @(posedge clk)
begin
if(regWrite == 1'b1)
begin
registers[rd] <= writeData;
end
end
endmodule

module controlUnit (instruction,regDst,branch,memRead,memToReg,ALUOp,memWrite,ALUSrc,regWrite);
input [5:0] instruction;
output regDst,branch,memRead,memToReg,memWrite,ALUSrc,regWrite;
output [2:0] ALUOp;

reg regDst,branch,memRead,memToReg,memWrite,ALUSrc,regWrite;
reg [2:0] ALUOp;

always @(instruction) begin
	if (instruction==6'b0) begin
		regDst <= 1'b1;
		branch <= 1'b0;
		memRead <= 1'b0;
		memToReg <= 1'b0;
		memWrite <= 1'b0;
		ALUSrc <= 1'b0;
		regWrite <= 1'b1;
		ALUOp <= 3'b101;
		
	end
	else begin
		case(instruction)
		6'b001000 : //addi
					begin
		            regDst <= 1'b0; 
					branch <= 1'b0; 
					memRead <= 1'b0; 
					memToReg <= 1'b0; 
					memWrite <= 1'b0; 
					ALUSrc <= 1'b1;
					regWrite <= 1'b1;
					ALUOp <= 3'b000;
					end

		6'b100011 : //lw
		            begin
		            regDst <= 1'b0; 
					branch <= 1'b0; 
					memRead <= 1'b1; 
					memToReg <= 1'b1; 
					memWrite <= 1'b0; 
					ALUSrc <= 1'b1;
					regWrite <= 1'b1;
					ALUOp <= 3'b000;
					end

		6'b101011 : //sw
		            begin
		            regDst <= 1'b0; 
					branch <= 1'b0; 
					memRead <= 1'b0; 
					memToReg <= 1'b0; 
					memWrite <= 1'b1; 
					ALUSrc <= 1'b1;
					regWrite <= 1'b0;
					ALUOp <= 3'b000;
					end

        6'b001100 : //andi
        			 begin
		            regDst <= 1'b0; 
					branch <= 1'b0; 
					memRead <= 1'b0; 
					memToReg <= 1'b0; 
					memWrite <= 1'b0; 
					ALUSrc <= 1'b1;
					regWrite <= 1'b1;
					ALUOp <= 3'b001;
					end

        6'b001101 : //ori
      				 begin
		            regDst <= 1'b0; 
					branch <= 1'b0; 
					memRead <= 1'b0; 
					memToReg <= 1'b0; 
					memWrite <= 1'b0; 
					ALUSrc <= 1'b1;
					regWrite <= 1'b1;
					ALUOp <= 3'b010;
					end  

        6'b000100 : //beq
                    begin
		            regDst <= 1'b0; 
					branch <= 1'b1; 
					memRead <= 1'b0; 
					memToReg <= 1'b0; 
					memWrite <= 1'b0; 
					ALUSrc <= 1'b0;
					regWrite <= 1'b0;
					ALUOp <= 3'b011;
					end

        6'b000101 : //bne
        			begin
		            regDst <= 1'b0; 
					branch <= 1'b1; 
					memRead <= 1'b0; 
					memToReg <= 1'b0; 
					memWrite <= 1'b0; 
					ALUSrc <= 1'b0;
					regWrite <= 1'b0;
					ALUOp <= 3'b100;
					end
		endcase
	end
end
endmodule


module ALUController(func,ALUOp,ALUControl);
input [5:0] func;
input [2:0] ALUOp;
output [2:0] ALUControl;

reg [2:0] ALUControl;

always @(func or ALUOp) begin
	if (ALUOp == 3'b101) begin
		case(func)
			6'b100000: ALUControl <= 3'b000; //ADD
			6'b100010: ALUControl <= 3'b001; //SUB
			6'b000000: ALUControl <= 3'b010; //SLL
			6'b000010: ALUControl <= 3'b011; //SRL
			6'b100100: ALUControl <= 3'b101; //AND
			6'b100101: ALUControl <= 3'b100; //OR
			6'b101010: ALUControl <= 3'b110; //SLT
			default: ALUControl <= 3'b000;

		endcase
		
	end
	else begin
		case(ALUOp)
			3'b000: ALUControl <= 3'b000; //ADDi, LW, SW 
			3'b001: ALUControl <= 3'b101; //ANDi 
			3'b010: ALUControl <= 3'b100; //ORi
			3'b011: ALUControl <= 3'b001; //BEQ 
			3'b100: ALUControl <= 3'b111; //BNE
			default: ALUControl <= 3'b000;
		endcase
	end
end
endmodule

module signExtend(in,out);
input [15:0] in;
output [31:0] out;

reg [31:0] out;

always @(in) begin
 	out <= {{16{in[15]}},in};
 end 
endmodule


module mux(in1,in2,select,out);
input in1,in2,select;
output out;

assign out = (select)?in2:in1;
endmodule


module IF_ID(clk,instructionIn,PCin,instructionOut,PCout);
input [31:0] instructionIn , PCin;
input clk;
output [31:0] instructionOut , PCout;
reg [31:0] instructionOut , PCout;
always @(posedge clk ) begin
	instructionOut <= instructionIn;
	PCout <= PCin;
end
endmodule

module ID_EX(clk,in,out);
input clk;
input [147:0] in;
output [147:0] out; 
reg [147:0] out;
always @(posedge clk ) begin
out <= in;
end
endmodule


module EX_MEM(clk,in,out);
input clk;
input [106:0] in;
output [106:0] out; 
reg [106:0] out;
always @(posedge clk ) begin
out <= in;
end
endmodule

module MEM_WB(clk,in,out);
input clk;
input [70:0] in;
output [70:0] out;
reg [70:0] out;
always @(posedge clk ) begin
out <= in;
end
endmodule



module instructionMemory(address,data);
input [31:0] address;
output [31:0]data;

reg [31:0] mem[0:127];
initial
    begin
    $readmemh("data1.txt",mem,0,127);
    end
assign data = mem[address[8:2]];
endmodule

module adder(in,out);
input [31:0] in;
output [31:0] out;

assign out = in+4;
endmodule


// module test;
// reg clk;
// reg [1:0] rs,rt,rd;
// reg[31:0] writeData;
// reg regWrite;
// wire [31:0] data1,data2;

// rf r (clk,rs,rt,rd,data1,data2,writeData,regWrite);
// initial begin
// clk = 0;
// forever begin
// #5 clk = ~clk;
// end
// end

// initial begin
// $monitor("time=%t data1=%h data2=%h clk=%h",$time,data1,data2,clk);
// #5 rs <= 2'b00;
// #5 rd <= 2'b01;
// #5 writeData <= 32'hd7;
// #5 regWrite <= 1;
// #5 rt <= 2'b01;
// end
// initial 
// #40 $finish;
// endmodule