`timescale 1ms/10ps
module tb_synckey;
logic [4:0] exp_out;
logic rst;
logic [19:0] in;
logic [4:0] out;
logic clk, strbout, exp_strb;

always
begin
    clk = 0;
    #5;
    clk = ~clk;
    #5;
end

synckey sync1 (.in(in), .out(out), .strbout(strbout), .clk(clk), .rst(rst));

    task toggle_reset;
        rst = 1;  
        #10;
        rst = 0;
        #10;
    endtask

    task chk_strb;
        if (rst == 1) 
        #10;
        exp_strb = 1;
        #10;
    endtask

initial begin
    // make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_synckey);
    #10;
    
    
    exp_out = 5'b0;
    //$display("exp_out = %b, out %b", exp_out, out);
    in = 20'b0;
    for (integer i = 0; i <= 19; i++) begin
        
        @(posedge clk); // delay inside the for loop repeat(2) @(poseedge clk)
        in[i] = 1'b1;
        
        toggle_reset();
        chk_strb();

        $display("exp_out is %b and out is %b", exp_out, out);

        if (exp_out != out)
            $display("EXP_OUT AND OUT ARE NOT THE SAME");

       
        $display("exp_strb is %b, and strbout is %b", exp_strb, strbout);
        if (exp_strb != strbout)
            $display("exp_strb does not match with strbout!");
        
        exp_out += 5'b0001;
    end

    // finish the simulation
    #1 
    $finish;
end

endmodule
