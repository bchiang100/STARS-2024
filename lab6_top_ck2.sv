`timescale 1ms/10ps
module tb_bcdadd1;

logic Cout, Cin;
logic [3:0] totalSum, sumTemp;
logic [3:0] A, B, S;

bcdadd1 test (.A(A), .B(B), .Cin(Cin), .Cout_bcd(Cout), .S2(S));

function integer bcdsum(A, B, Cin);
  sumTemp = A + B + Cin;
  return(sumTemp);
endfunction

initial begin
    // make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_bcdadd1);

    // for loop to test all possible inputs
    for (integer i = 0; i <= 9; i++) begin
        for (integer j = 0; j <= 9; j++) begin
            for (integer k = 0; k <= 3; k++) begin
                // set our input signals
                //A = i; B = j; Cin = k;
                A = {i[0], i[1], i[2], i[3]};
                B = {j[0], j[1], j[2], j[3]};
                Cin = k[0];
                #1;
                // display inputs and outputs
                $display("A=%b, B=%b, Cin=%b, Cout=%b, S=%b", A, B, Cin, Cout, S);
                
                  if (bcdsum(A, B, Cin) > 9 || Cout) begin   
                    totalSum = bcdsum(A, B, Cin) + 6;
                  end
                  else begin
                    totalSum  = bcdsum(A, B, Cin) +  0;
                  end
                end
            
        end
    end

    // finish the simulation
    #1 $finish;
end

endmodule
