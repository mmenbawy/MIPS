`timescale 1ns/100ps
module tst();
reg clk;
MIPSprocessor mips (clk);

initial
begin
clk = 1;
forever begin
#400 clk = ~clk;
end
end

initial
#15000 $finish;
initial
$monitor("time=%t clk=%h", $time, clk);
endmodule