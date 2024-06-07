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
  logic clk, rst;
  logic [4:0] carry;

  assign clk = hz100;
  assign rst = reset;
  assign carry = right[4:0];
  //synckey sync1 (.in(pb[19:0]), .out(carry), .strbout(green), .clk(clk), .rst(rst));
  logic [7:0] carry8;
  assign carry8 = {3'b0, carry};
  //ssdec ssdec1 (.in(carry8[3:0]), .enable(1'b1), .out(ss0[6:0]));
  //ssdec ssdec2 (.in(carry8[7:4]), .enable(1'b1), .out(ss1[6:0]));
  
endmodule
module ssdec (
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

module synckey (
  input logic [19:0] in,
  output logic [4:0] out,
  input logic clk, rst,
  output logic strbout
);
  logic strobin;
  assign strobin = |in;

  logic [31:0] i;
  logic Q1, Q0, D1, D0;

  
 always_ff @(posedge clk, posedge rst)
  if (rst) begin
     Q0 <= 0;
     Q1 <= 0;
  end
  else begin
    D0 <= strobin;
    Q0 <= D0;
    D1 <= Q0;
    Q1 <= D1;
    strbout <= Q1;
  end

  always_ff @(posedge strbout, posedge rst)
  if (rst) 
     out = 5'b0;
  else begin
    //always_comb begin
    //out = 0;
    for(i = 0; i < 32; i++)
      if (in[i[4:0]])
      out = i[4:0];
    //end
  end
endmodule
