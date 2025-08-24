module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);
// Seu codigo aqui    

	wire [7:0] last_8bits;
	reg [7:0] palavra_valida;
	
	reg enable_sr;
	wire palavra_igual;
	
	assign palavra_igual = (palavra_valida == last_8bits);
		
	shift_register_left dut_sr(
		.D(8'b00000000),
		.clk(clk),
		.L(bit_in), 
		.en(enable_sr), 
		.load(1'b0), 
		.rst_n(rst_n), 
		.Q(last_8bits)
	);
	
	reg [2:1] y, Y;   //y is the current state
	                  //Y is the next state.
	parameter [2:1] STATE_RESET = 2'b00, STATE_SET = 2'b01, STATE_FINDING = 2'b10, STATE_FOUND = 2'b11;

	always @(negedge rst_n, posedge clk)
		if (rst_n == 0) y <= STATE_RESET;
		else y <= Y;

	always @(setar_palavra, start, palavra_igual, y)
		case (y)
			STATE_RESET: if (setar_palavra) Y = STATE_SET;
						 else Y = STATE_RESET;
			STATE_SET: 	 if (start) Y = STATE_FINDING;
						 else Y = STATE_SET;
			STATE_FINDING: if (palavra_igual) Y = STATE_FOUND;
						   else Y = STATE_FINDING;
			STATE_FOUND: Y = STATE_FOUND;
			default: Y = STATE_RESET;
		endcase
	
	always @(y)
		case (y)
			STATE_RESET: 
				begin
					enable_sr = 0;
					encontrado = 0;
				end
			STATE_SET: 	
				begin
					palavra_valida = palavra;
					enable_sr = 0;
					encontrado = 0;
				end
			STATE_FINDING:
				begin
					enable_sr = 1;
					encontrado = 0;
				end
			STATE_FOUND: 
				begin
					enable_sr = 0;
					encontrado = 1;
				end
			default: 
				begin
					enable_sr = 0;
					encontrado = 0;
				end
		endcase
	

endmodule
