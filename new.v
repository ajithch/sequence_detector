
module detector(y,x,clk,reset); // structural module

input x,reset; //input x is sequence of the data
input clk;	
output y;

reg q0,q1,q2;

wire d0,d1,d2;
wire y;

// external circuit for inputs of the D-filpflops.
// external circuit by dataflow modeling

// d0

assign d0 = ( (q1 & (~q0)) | (x & (~q1)) );   

// d1

assign d1 = ((~x) & ( q2 | (q1 ^ q0) ));


//d2

assign d2 = ( q1 & q0 & x );


// y

assign y = ( x & (~q2) & q1 & q0 );

// d filpflop using behaviour modeling

always @(negedge clk) // three D filpflops with d0,d1,d2 as input and q0,q1,q2 as outputs
begin
	if(reset) 
		begin
			q0 <= 1'b0 ;
			q1 <= 1'b0 ;
			q2 <= 1'b0 ;
		end

	else
		begin
			q0 <= d0 ;
			q1 <= d1 ;
			q2 <= d2 ;
		end
end
endmodule





module testbench ;  //testbench 

reg reset, clk, x;
reg [23:0] data;
integer i;

detector det(.y(y),.x(x),.clk(clk),.reset(reset));//function calling


initial 
	begin
		data = 24'b100100100001100100010110;
		i = 0;
	$monitor($time, "clk=%b,reset=%b,x=%b,y=%b",clk,reset,x,y);
		reset = 1'b1; 
		#10 reset = 1'b0;
		#500 $stop;
	end

initial 
	begin
		clk = 0;
	forever begin
		#5 clk = ~clk;
	end
	end

always @ (posedge clk)

	begin
		x = data >> i;
		i = i+1;
	end
endmodule







