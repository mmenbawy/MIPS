module forwardingUnit(forwardA,forwardB,IDrs,IDrt,EXrd,MEMrd,EXregWrite,MEMregWrite);
output forwardA;
output forwardB;
reg [1:0] forwardA;
reg [1:0] forwardB;
input [4:0]IDrs;
input [4:0]IDrt;
input [4:0] EXrd;
input [4:0]MEMrd;
input EXregWrite;
input MEMregWrite;

//forwardA from ALU to ALU and from MEM to ALU 
always@(MEMregWrite or EXregWrite or MEMrd or EXrd or IDrt or IDrs)
begin
if((EXregWrite==1'b1) && (EXrd != 5'b0) && (EXrd==IDrs) )
		forwardA <=2'b10;
		else if ((MEMregWrite==1'b1) && (MEMrd !=5'b0) && (MEMrd==IDrs) && ((EXregWrite!=1'b1) || (EXrd ==5'b0) || (EXrd!=IDrs)))
		forwardA <=2'b01;
		else begin
			forwardA <=2'b00;
		end
end


//forwardA from ALU to ALU and from MEM to ALU 
always@(MEMregWrite or EXregWrite or MEMrd or EXrd or IDrt or IDrs)
begin
if((EXregWrite==1'b1) && (EXrd != 5'b0) && (EXrd==IDrt) )
		forwardB <=2'b10;
		else if ((MEMregWrite==1'b1) && (MEMrd !=5'b0) && (MEMrd==IDrt) && ((EXregWrite!=1'b1) || (EXrd ==5'b0) || (EXrd!=IDrt)))
		forwardB <=2'b01;
		else begin
			forwardB <=2'b00;
		end
end


endmodule
