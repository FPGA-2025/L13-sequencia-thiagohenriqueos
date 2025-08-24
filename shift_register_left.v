module shift_register_left(D, clk, L, en, load, rst_n, Q);
	input [7:0] D;
	input clk, L, en, load, rst_n;
	output reg [7:0] Q;
	
	always @(posedge clk, negedge rst_n)
	begin
		if (rst_n == 0)
			Q <= 16'b00000000;
		else
			if (en == 1)
			begin
				if (load == 1)
				begin
					Q <= D;
				end
				else
					begin
						Q[ 7] <= Q[ 6];
						Q[ 6] <= Q[ 5];
						Q[ 5] <= Q[ 4];
						Q[ 4] <= Q[ 3];	
						Q[ 3] <= Q[ 2];
						Q[ 2] <= Q[ 1];
						Q[ 1] <= Q[ 0];				
						Q[ 0] <= L;
					end
			end
	end
endmodule