module MEM ( readData,address,writeData,memWrite,memRead);
output [31:0] readData;
input memRead;
input memWrite;
input[31:0] writeData;
input [31:0] address;
reg[31:0] readData;
reg  [0:7] memSlots [67108863:0];
always @(address or writeData or memWrite or memRead) begin
 	if(memRead)
 	readData = {memSlots[address[25:0]],memSlots[address[25:0]+1],memSlots[address[25:0]+2],memSlots[address[25:0]+3]};
 end 
 always @(address or writeData or memWrite or memRead) begin
 	
if(memWrite)
	begin
		memSlots[address[25:0]] <= writeData[31:24];
		memSlots[address[25:0]+1] <= writeData[23:16];
		memSlots[address[25:0]+2] <= writeData[15:8];
		memSlots[address[25:0]+3] <= writeData[7:0];
	end
 end
 endmodule