`timescale 1ms/10ps
module tb_display;  //

 logic [3:0] state;
 logic [31:0] seq;
 logic [63:0] ss;
 logic [63:0] exp_ss;
 logic red, green, blue;
 logic exp_red, exp_green, exp_blue;

display display1 (   
 .state(state),
 .seq(seq),
 .ss(ss),
 .red(red), .green(green), .blue(blue)
);



initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_display);
end

initial begin

        
  #20;
  state = 4'b0000;
  seq = 32'h12345678;
  exp_blue  = 1'b0;
  exp_green = 1'b0;
  exp_red   = 1'b0;
  exp_ss    = 64'h0000000000000000;

  $display(" LS_0- off, state = %b, seq= %b exp_ss: %h ss: %h", state, seq, exp_ss, ss);
  if(ss != exp_ss)
    $display("error: ss doesn't match expected_ss"); 

  
  #20;
  state = 'h000A; //init
  seq = 32'h12345678;
  exp_blue  = 1'b0;
  exp_green = 1'b0;
  exp_red   = 1'b0;
  exp_ss    = 64'h12345678;

  $display(" init: state = %b, seq= %b exp_ss: %h ss: %h", state, seq, exp_ss, ss);
  if(ss != exp_ss)
    $display("error: ss doesn't match expected_ss"); 

  #20;
  state = 'h0001; //Ls0 - Ls7
  seq = 32'h12345678;
  exp_blue  = 1'b0;
  exp_green = 1'b0;
  exp_red   = 1'b0;
  exp_ss    = 64'h23456781;

  $display(" init: state = %b, seq= %b exp_ss: %h ss: %h", state, seq, exp_ss, ss);
  if(ss != exp_ss)
    $display("error: ss doesn't match expected_ss"); 

  #20;
  state = 4'b1000; //open
  seq = 32'h1234567A;
  exp_blue  = 1'b0;
  exp_green = 1'b0;
  exp_red   = 1'b0;
  exp_ss    = 64'h0000000000007937; //open

  $display("open state = %b, seq= %b exp_ss: %h ss: %h", state, seq, exp_ss, ss);
  if(ss != exp_ss)
    $display("error: ss doesn't match expected_ss");   

   #20;
  state = 4'b1001; //alarm
  seq = 32'h1234567A;
  exp_blue  = 1'b0;
  exp_green = 1'b0;
  exp_red   = 1'b0;
  exp_ss    = 64'h00000000CA00911; //call 911

  $display("alarm state = %b, seq= %b exp_ss: %h ss: %h", state, seq, exp_ss, ss);
  if(ss != exp_ss)
    $display("error: ss doesn't match expected_ss");     
  //finish the simulation
  #1
  $finish;
end
endmodule

`default_nettype none
// Empty top module
