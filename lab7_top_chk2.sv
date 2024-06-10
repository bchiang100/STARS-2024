`default_nettype none

typedef enum logic [3:0] {
LS0=0, LS1=1, LS2=2, LS3=3, LS4=4, LS5=5, LS6=6, LS7=7,
OPEN=8, ALARM=9, INIT=10
} state_t;

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
logic [31:0] seq;
logic strobe;

assign clk=hz100;
assign rst=reset;
assign seq = 32'h12345678;
assign red = strobe;

state_t current_state;
logic [4:0] out5;
assign right[4:0] = out5;
assign left[3:0] = current_state;
logic [7:0] out8;

synckey sync1 (.clk(clk), .rst(rst), .in(pb[19:0]), .out(out5), .strbout(strobe));
fsm fsm1 (.clk(red), .rst(rst), .keyout(out5), .seq(seq), .state(current_state));

assign blue = (current_state == OPEN) ? 1 : 0;

always_ff @(posedge strobe, posedge rst) begin
  if (rst) begin
    out8 <= 8'b0;
  end else begin
    out8 <= {3'b0, out5};
  end
end
ssdec ssdec1 (.in(out8[3:0]), .enable(1'b1), .out(ss0[6:0]));
ssdec ssdec2 (.in(out8[7:4]), .enable(1'b1), .out(ss1[6:0]));
ssdec s7 (.in(current_state), .enable(1'b1), .out(ss7[6:0]));

endmodule

module fsm(
input logic clk, rst,
input logic [4:0] keyout,
input logic [31:0] seq,
output state_t state
);
state_t next_state;

always_ff @(posedge clk, posedge rst) // sequential logic
    if (rst) begin
        state <= INIT;
    end
    else begin
        state <= next_state;
    end

always_comb begin
  next_state = state;

  case(state)
    INIT:
      if (keyout == 5'b10000) begin
        next_state = LS0;
      end
    LS0: begin
      if (keyout == 5'b10000) begin
          next_state = LS0;
      end
      else if (keyout[3:0] == seq[31:28]) begin
          next_state = LS1;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS1: begin
      if (keyout == 5'b10000) begin
        next_state = LS0;
      end
      else if (keyout[3:0] == seq[27:24]) begin
        next_state = LS2;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS2: begin
      if (keyout == 5'b10000) begin
        next_state = LS0;
      end
      else if (keyout[3:0] == seq[23:20]) begin
        next_state = LS3;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS3: begin
      if (keyout == 5'b10000) begin
          next_state = LS0;
      end
      else if (keyout[3:0] == seq[19:16]) begin
        next_state = LS4;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS4: begin
      if (keyout == 5'b10000) begin
          next_state = LS0;
      end
      else if (keyout[3:0] == seq[15:12]) begin
        next_state = LS5;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS5: begin
      if (keyout == 5'b10000) begin
          next_state = LS0;
      end
      else if (keyout[3:0] == seq[11:8]) begin
        next_state = LS6;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS6: begin
      if (keyout == 5'b10000) begin
          next_state = LS0;
      end
      else if (keyout[3:0] == seq[7:4]) begin
        next_state = LS7;
      end
      else begin
        next_state = ALARM;
      end
    end
    LS7: begin
      if (keyout == 5'b10000) begin
          next_state = LS0;
      end
      else if (keyout[3:0] == seq[3:0]) begin
        next_state = OPEN;
      end
      else begin
        next_state = ALARM;
      end
    end
    OPEN: begin
      if (keyout == 5'b10000)
        next_state = LS0;
    end
    default: begin
      next_state = state;
    end
  endcase
end

endmodule

module synckey(
input logic clk, rst,
input logic [19:0] in,
output logic strbout,
output logic [4:0] out
);

logic  strbin;
assign strbin = |in;
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

 always_comb begin
    out = 0;
    for(i = 0; i < 20; i++)
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
