`timescale 1ms/10ps
module tb_bcdadd1;

logic Cout, Cin;
logic [3:0] totalSum, sumTemp;
logic [3:0] A, B, S;

bcdadd1 test (.A(A), .B(B), .Cin(Cin), .Cout_bcd(Cout), .S2(S));

function integer bcdsum(logic [3:0] A, B, Cin);
  sumTemp = A + B + Cin;

  if ({Cout, S} == sumTemp) begin   
    totalSum = sumTemp + 6;
    end
    else begin
      totalSum  = sumTemp +  0;
    end
  

  return(sumTemp);
endfunction

initial begin
    // make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_bcdadd1);

    // for loop to test all possible inputs
    for (integer i = 0; i <= 9; i++) begin
        for (integer j = 0; j <= 9; j++) begin
            for (integer k = 0; k <= 1; k++) begin
                // set our input signals
                //A = i; B = j; Cin = k;
                A = {i[3], i[2], i[1], i[0]};
                B = {j[3], j[2], j[1], j[0]};
                Cin = k[0];
                #1;
                // display inputs and outputs
                $display("A=%b, B=%b, Cin=%b, Cout=%b, S=%b", A, B, Cin, Cout, S);

                if (S == sumTemp) begin 
                  $display("\n%b is the same as %b\n", S, sumTemp);
                end
                // if (bcdsum(A, B, Cin) > 9) begin
                //   $display("%d is also the same as %b\n", Cout, sumTemp);
                // end
            end
            
        end
    end

    // finish the simulation
    #1 $finish;
end

endmodule
