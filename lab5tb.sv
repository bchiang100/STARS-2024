`timescale 1ms/10ps
module tb;

logic [3:0]A, B, S;
logic Cin, Cout;

//fa fulladder (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

fa4 fulladder (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
initial begin
    // make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb);

    // for loop to test all possible inputs
    for (integer i = 0; i <= 15; i++) begin
        for (integer j = 0; j <= 15; j++) begin
            for (integer k = 0; k <= 3; k++) begin
                // set our input signals
                A = i; B = j; Cin = k;
                #1;
                // display inputs and outputs
                $display("A=%b, B=%b, Cin=%b, Cout=%b, S=%b", A, B, Cin, Cout, S);
            end
        end
    end

    // finish the simulation
    #1 $finish;
end
endmodule
