module MIPSprocessor(clk);
input clk;
wire [31:0] muxFourOut;
reg [31:0] PC;
wire [106:0] out_r3;
wire PCsrc;
always @(posedge clk) begin
	if (PC === 32'bx) begin
	PC = 32'b0;
		
	end
	else begin
	if(PCsrc==1'b0 || PCsrc===1'bx || PCsrc===1'bz) begin
		PC = PC + 4;		
	end
		else begin
			PC = out_r3[101:70];
		end
	end
	$display("PC=%b", PC);
end


//wires
wire [31:0] instruction;
wire [31:0] instructionOut;
wire [31:0] PCout;
wire [31:0] data1;
wire [31:0] data2;
wire [31:0] outSign;
wire regDst;
wire branch;
wire memRead;
wire memToReg;
wire [2:0] ALUOp;
wire memWrite;
wire ALUSrc;
wire regWrite;
wire [147:0] out_r2;
wire [2:0]ALUControl;
wire [4:0] muxOneOut;
//wire [31:0]PCplusFour;
wire [31:0] muxTwoOut;
wire [31:0] shifted;
wire [31:0] branchPC;
wire [31:0]ALUout;
wire zero;

wire [31:0] readData;

wire [70:0]out_r4;
wire [31:0] muxThreeOut;
wire [31:0] PCplusFour;

assign PCplusFour = PC + 3'b100;
//assign PCplusFour = PC + 4;
instructionMemory im (PC,instruction);
//adder PCadder (PC,PCplusFour);
IF_ID r1 (clk,instruction,PCplusFour,instructionOut,PCout);
registerFile rf (clk,instructionOut[25:21],instructionOut[20:16],out_r4[4:0],data1,data2,muxThreeOut,out_r4[70]);
signExtend sign (instructionOut[15:0],outSign);
controlUnit CU (instructionOut[31:26],regDst,branch,memRead,memToReg,ALUOp,memWrite,ALUSrc,regWrite);

wire [9:0] controlOut ;
assign controlOut =  {regDst,branch,memRead,memToReg,ALUOp,memWrite,ALUSrc,regWrite};
//decode
always @(posedge clk) begin
$display("decode rs = %b rt = %b control = %b",instructionOut[25:21],instructionOut[20:16],controlOut);
end

//stage3
ID_EX r2(clk,{regWrite,memToReg,branch,memRead,memWrite,regDst,ALUOp,ALUSrc,PCout,data1,data2,outSign,instructionOut[20:16],instructionOut[15:11]},out_r2);
assign muxOneOut = out_r2[142]?out_r2[4:0]:out_r2[9:5];
ALUController aluc (out_r2[15:10],out_r2[141:139],ALUControl);
assign muxTwoOut = out_r2[138]?out_r2[41:10]:out_r2[73:42];
assign shifted = out_r2[41:10] << 2'b10 ; //mult 4
assign branchPC = shifted + out_r2[137:106];
ALU alu (ALUout,zero, out_r2[105:74],muxTwoOut,ALUControl,out_r2[20:16]);

always @(posedge clk) begin
$display("Execute rd=%b rt=%b ALUResult=%b zero=%b branchPC=%b Extended=%b",out_r2[4:0],out_r2[9:5],ALUout,zero,branchPC,out_r2[41:10] );
end


//stage4
EX_MEM r3 (clk,{out_r2[147],out_r2[146],out_r2[145],out_r2[144],out_r2[143],branchPC,zero,ALUout,out_r2[73:42],muxOneOut},out_r3);
MEM memory(readData,out_r3[68:37],out_r3[36:5],out_r3[102],out_r3[103]);
assign PCsrc = out_r3[69] & out_r3[104] ;

always @(posedge clk) begin
$display("WB  PCsrc=%b",PCsrc);
end

//stage5
MEM_WB r4 (clk,{out_r3[106],out_r3[105],readData,out_r3[68:37],out_r3[4:0]},out_r4);
assign muxThreeOut =out_r4[69]?out_r4[68:37]:out_r4[36:5];

always @(posedge clk) begin
$display("WB  writeData=%b writeRegister=%d regWrite=%d",muxThreeOut,out_r4[4:0],out_r4[70]);
end
endmodule

