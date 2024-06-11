`timescale 1ms/10ps
module tb_sequence_sr;  //
   logic clk, rst, en;
   logic [4:0]in;
   logic [31:0] exp_out, out;


always
begin
    clk = 0;
    #5;
    clk = ~clk;
    #5;
end

sequence_sr sequence_sr1   
 (.clk(clk), .rst(rst), .en(en), .in(in), .out(out));

    task toggle_reset;
        rst = 1;  
        #10;
        exp_out = 32'h0; 
        rst = 0;  
        #10;
        exp_out = 32'h12345678; // FIXED SEQUENCE
    endtask

    

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_sequence_sr);
end

initial begin
  
          
  @(posedge clk); //delay inside the for loop 


  toggle_reset(); //task

  #20;
  en =1'b1; // init, shift as the button is pressed
  in = 5'b01010;
  exp_out = {exp_out[27:0], in[3:0]}; 
  
  $display("time: %0t en: %b in: %h exp_out = %b, out= %b", $time, en, in, exp_out, out);
  if(exp_out != out)
    $display("error: exp_out doesn't match out");
       
  #20;
  in = 5'b01011;
  exp_out = {exp_out[27:0], in[3:0]}; 
  $display("time: %0t en: %b in: %h exp_out = %b, out= %b", $time, en, in, exp_out, out);
  if(exp_out != out)
    $display("error: exp_out doesn't match out");

  #20;
  en =1'b0; // when in Ls0- LS7, should not shift
  in = 5'b01100;
  exp_out = {exp_out[27:0], in[3:0]}; 
  $display("time: %0t en: %b in: %h exp_out = %b, out= %b", $time, en, in, exp_out, out);
  if(exp_out != out)
    $display("error: exp_out doesn't match out");       
  //finish the simulation
  #1
  $finish;
end
endmodule

`default_nettype none
// Empty top module
