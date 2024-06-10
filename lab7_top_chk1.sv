`default_nettype none
// Empty top module

module top (
 // I/O ports
 input  logic hz100, reset,
 input  logic [20:0] pb,
 output logic [7:0] left, right,
        ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
 output logic red, green, blue,

 // UART ports
 output logic [7:0] txdata,
 input  logic [7:0] rxdata,
 output logic txclk, rxclk,
 input  logic txready, rxready
);
state_t current_state;
logic clk, rst;

assign clk=hz100;
assign rst=reset;

logic [4:0] out5;
assign out5 = right[4:0];

synckey sync1 (.clk(clk), .rst(rst), .in(pb[19:0]), .out(out5), .strbout(red));

logic [7:0] out8 = {3'b0, out5};
ssdec ssdec1 (.in(out8[3:0]), .enable(1'b1), .out(ss0[6:0]));
ssdec ssdec2 (.in(out8[7:4]), .enable(1'b1), .out(ss1[6:0]));

endmodule

module synckey(
input logic clk, rst,
input logic [19:0] in,
output logic strbout,
output logic [4:0] out
);

assign strbin = |in;
logic  strbin;
logic [31:0] i;
logic Q1, Q0;
assign Q1 = strbout;

always_ff @(posedge clk, posedge rst)
 if (rst) begin
    Q0 <= 0;
    Q1 <= 0;
 end
 else begin
    Q0 <= strbin;
    Q1 <= Q0;
 end
 
always_ff @(posedge strbout, posedge rst)
 if (rst)
    out =5'b0; 
 else begin
   for(i = 0; i < 32; i++)
     if (in[i[4:0]])
     out = i[4:0];
   end

endmodule

module ssdec(

 input logic [3:0] in,
 input logic enable,
 output logic [6:0] out
);

 always_comb begin
   case(in)
     4'b0000: begin out = 7'b0111111; end
     4'b0001: begin out = 7'b0000110; end
     4'b0010: begin out = 7'b1011011; end
     4'b0011: begin out = 7'b1001111; end
     4'b0100: begin out = 7'b1100110; end
     4'b0101: begin out = 7'b1101101; end
     4'b0110: begin out = 7'b1111101; end
     4'b0111: begin out = 7'b0000111; end 
     4'b1000: begin out = 7'b1111111; end 
     4'b1001: begin out = 7'b1100111; end 
     4'b1010: begin out = 7'b1110111; end
     4'b1011: begin out = 7'b1111100; end 
     4'b1100: begin out = 7'b0111001; end
     4'b1101: begin out = 7'b1011110; end
     4'b1110: begin out = 7'b1111001; end
     4'b1111: begin out = 7'b1110001; end


     default: begin out = '0; end 
 endcase 
 end
endmodule



