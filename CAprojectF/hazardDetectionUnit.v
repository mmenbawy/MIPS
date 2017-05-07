module hazardDetectionUnit(PCWrite,IFDWrite,muxSelect,IDEXMEMRead,IDEXRt,IFIDRs,IFIDRt);
input [4:0] IFIDRs;
input [4:0] IFIDRt;
input [4:0] IDEXRt;
input IDEXMEMRead;
output PCWrite;
output IFDWrite;
output muxSelect;
reg PCWrite;
reg IFDWrite;
reg muxSelect;

always @(IDEXMEMRead or IDEXRt or IFIDRs or IFIDRt) begin
	if ((IDEXMEMRead==1'b1) && ((IDEXRt==IFIDRt) || (IDEXRt==IFIDRs))) 
	begin
		PCWrite <=1'b0;
		IFDWrite <=1'b0;
		muxSelect <=1'b1;
				
	end
	else begin
		PCWrite <=1'b1;
		IFDWrite <=1'b1;
		muxSelect <=1'b0;
		
	end
end
endmodule