`timescale 1ps/1ps

import ImageWriter_pkg::*;

module tb();

  localparam WIDTH  = 4096;
  localparam HEIGHT = 4096;

  logic                      clk    = 0;
  logic                      reset  = 0;
  logic                      h_sync    ;
  logic                      v_sync    ;
  logic                      de        ;
  logic [              23:0] data      ;
  logic [ $clog2(WIDTH)-1:0] x         ;
  logic [$clog2(HEIGHT)-1:0] y         ;

  logic flag = 0;

  default clocking main @(posedge clk);
  endclocking

  initial forever #1 clk = ~clk;

  ImageWriter Writer;

  initial 
    begin
      Writer = new;
      Writer.init(WIDTH, HEIGHT);
      Writer.save_file("test.bmp");
    end

  initial
    begin
      ##2 reset = 1;
      ##1 reset = 0;
      flag = 1;
    end

  always @(fg_inst.end_frame iff flag) begin
    ##2 Writer.save_file("ololo.bmp");
    $finish;
  end

  frame_gen #(
    .WIDTH  (WIDTH ),
    .HEIGHT (HEIGHT),
    .H_FRONT(3     ),
    .H_SYNC (5     ),
    .H_BACK (8     ),
    .V_FRONT(1     ),
    .V_SYNC (3     ),
    .V_BACK (5     )
  ) fg_inst (
    .clk   (clk   ),
    .reset (reset ),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .de    (de    ),
    .x     (x     ),
    .y     (y     ),
    .frame (frame )
  );

  draw_cross #(
    .WIDTH (WIDTH ),
    .HEIGHT(HEIGHT)
  ) dc_inst (
    .clk  (clk  ),
    .reset(reset),
    .x    (x    ),
    .y    (y    ),
    .data (data ),
    .frame(frame)
  );

  always_ff @(posedge clk)
    if (de)
      Writer.add_pixel(data);

endmodule