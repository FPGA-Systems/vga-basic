module frame_gen #(
	parameter WIDTH   = 800,
	parameter HEIGHT  = 600,
	parameter H_FRONT = 40 ,
	parameter H_SYNC  = 128,
	parameter H_BACK  = 88 ,
	parameter V_FRONT = 1  ,
	parameter V_SYNC  = 4  ,
	parameter V_BACK  = 23
) (
	input                             clk   ,
	input                             reset ,
	output logic                      h_sync,
	output logic                      v_sync,
	output logic                      de    ,
	output logic [              23:0] data  ,
	output       [ $clog2(WIDTH)-1:0] x     ,
	output       [$clog2(HEIGHT)-1:0] y,
	output                            frame
);

	localparam full_x  = WIDTH+H_FRONT+H_SYNC+H_BACK ;
	localparam full_y  = HEIGHT+V_FRONT+V_SYNC+V_BACK;
	localparam blank_x = H_FRONT+H_SYNC+H_BACK       ;
	localparam blank_y = V_FRONT+V_SYNC+V_BACK       ;

	logic [$clog2(full_x)-1:0] pix_cnt ;
	logic [$clog2(full_y)-1:0] line_cnt;

	assign x = pix_cnt - blank_x;
	assign y = line_cnt - blank_y;

`ifdef MODELSIM
	event end_frame;
`endif

	always_ff @(posedge clk or posedge reset)
		if (reset)
			begin
				pix_cnt  <= '0;
				line_cnt <= '0;
				frame    <= '0;
			end
		else
			begin
				if (pix_cnt < full_x - 1'b1)
					begin
						frame   <= '0;
						pix_cnt <= pix_cnt + 1'b1;
					end
				else
					begin
						pix_cnt <= '0;
						if (line_cnt < full_y - 1'b1)
							begin
								line_cnt <= line_cnt + 1'b1;
								frame    <= '0;
							end
						else
							begin
								`ifdef MODELSIM
									-> end_frame;
								`endif
								frame    <= '1;
								line_cnt <= '0;
							end
					end
			end

	always_ff @(posedge clk or posedge reset)
		begin
			if (reset)
				begin
					h_sync <= '0;
					v_sync <= '0;
					de     <= '0;
					data   <= '0;
				end
			else
				begin
					h_sync <= (pix_cnt  < H_BACK || pix_cnt  > (H_SYNC + H_BACK - 1'b1)) ? 1'b1 : 1'b0;
					v_sync <= (line_cnt < V_BACK || line_cnt > (V_SYNC + V_BACK - 1'b1)) ? 1'b1 : 1'b0;
					de     <= (pix_cnt  > (blank_x - 1'b1) && line_cnt > (blank_y - 1'b1) ) ? 1'b1 : 1'b0;
					if (pix_cnt > (blank_x - 1'b1) && line_cnt > (blank_y - 1'b1) )
						data <= x;
					else
						data <= '0;
				end
		end

endmodule