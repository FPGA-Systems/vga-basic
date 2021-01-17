module top (
  input        clk   ,
  output       h_sync,
  output       v_sync,
  output [4:0] red   ,
  output [5:0] green ,
  output [4:0] blue,
  output led,
  output led2
);

  localparam WIDTH  = 1280;
  localparam HEIGHT = 1024;

  logic locked   ;
  logic video_clk;

  logic [ $clog2(WIDTH)-1:0] x;
  logic [$clog2(HEIGHT)-1:0] y;

  logic [23:0] data;

  assign red   = data[16+:5];
  assign green = data[8+:6];
  assign blue  = data[0+:5];

  pll pll_inst (
    .areset(1'b0     ),
    .inclk0(clk      ),
    .c0    (video_clk),
    .locked(locked   )
  );
  
  frame_gen #(
    .WIDTH  (WIDTH ),
    .HEIGHT (HEIGHT),
    .H_FRONT(16    ),
    .H_SYNC (144   ),
    .H_BACK (248   ),
    .V_FRONT(1     ),
    .V_SYNC (3     ),
    .V_BACK (38    )
  ) fg_inst (
    .clk   (video_clk),
    .reset (~locked  ),
    .h_sync(h_sync   ),
    .v_sync(v_sync   ),
    .de    (de       ),
    .x     (x        ),
    .y     (y        ),
    .frame (frame    )
  );

  draw_cross #(
    .WIDTH (WIDTH ),
    .HEIGHT(HEIGHT)
  ) dc_inst (
    .clk  (video_clk),
    .reset(~locked  ),
    .x    (x        ),
    .y    (y        ),
    .data (data     ),
    .frame(frame    )
  );

endmodule
