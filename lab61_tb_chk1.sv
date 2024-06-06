`timescale 1ms/10ps
module tb_ssdec;
logic [3:0] in;
logic enable;
logic [6:0] ssX;
ssdec s0 (.in(in), .enable(enable), .out(ssX));

function integer ss_to_int(logic [6:0] ss);
  case(ss)
    7'b0111111: return 0;
    7'b0000110: return 1;
    7'b1011011: return 2;
    7'b1001111: return 3;
    7'b1100110: return 4;
    7'b1101101: return 5;
    7'b1111100: return 6;
    7'b0000111: return 7;
    7'b1111111: return 8;
    7'b1100111: return 9;
    7'b1110111: return 10;
    7'b1111100: return 11;
    7'b0111001: return 12;
    7'b1011110: return 13;
    7'b1111001: return 14;
    7'b1110001: return 15;

    default: return -1; // if we make a mistake!
  endcase
endfunction

initial begin
  $dumpfile("sim.vcd");
  $dumpvars(0, tb_ssdec);
  enable = 1;
  #10;
  for (integer i = 0; i < 16; i++) begin
    in = i;
    #10;
    if (ss_to_int(ssX) != i)
      $display("Error: %d != %d", ss_to_int(ssX), i);
  end
end

endmodule
