module draw_cross #(
	parameter WIDTH  = 800,
	parameter HEIGHT = 600
) (
	input                             clk      ,
	input                             reset    ,
	input        [ $clog2(WIDTH)-1:0] x        ,
	input        [$clog2(HEIGHT)-1:0] y        ,
	input                             frame,
	output logic [              23:0] data
);

	localparam CROSS_SIZE = 100;

	logic [ $clog2(WIDTH):0] cross_X;
	logic [$clog2(HEIGHT):0] cross_Y;
	logic dir_x;
	logic dir_y;

	typedef enum logic [23:0]{
		BLACK = 24'h012345,
		RED   = 24'hFF0000,
		GREEN = 24'h00FF00,
		BLUE  = 24'h0000FF
	} color_t;

	color_t color;

	always_ff @(posedge clk or posedge reset)
		begin
			if (reset)
				begin
					cross_X <= '0;
					cross_Y <= '0;
					dir_x   <= '0;
					dir_y   <= '0;
					color   <= color.first();
				end
			else
				begin
					if (frame)
						begin
							if (dir_x)
								begin
									if (cross_X < ( WIDTH - CROSS_SIZE ) )
										cross_X <= cross_X + 1'b1;
									else
										begin
											dir_x <= ~dir_x;
											color <= color.next();
										end
								end
							else
								begin
									if (cross_X > 0)
										cross_X <= cross_X - 1'b1;
									else
										begin
											dir_x <= ~dir_x;
											color <= color.next();
										end
								end
							if (dir_y)
								begin
									if (cross_Y < ( HEIGHT - CROSS_SIZE ) )
										cross_Y <= cross_Y + 1'b1;
									else
										begin
											dir_y <= ~dir_y;
											color <= color.next();
										end
								end
							else
								begin
									if (cross_Y > 0)
										cross_Y <= cross_Y - 1'b1;
									else
										begin
											dir_y <= ~dir_y;
											color <= color.next();
										end
								end
						end
				end
		end

	always_comb
		begin
			if (x < (cross_X + CROSS_SIZE) && x >= cross_X && y < (cross_Y + CROSS_SIZE) && y >= cross_Y )
				data = color;
			else
				data = '0;
		end

endmodule