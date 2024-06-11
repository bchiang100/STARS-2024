`timescale 1ms/10ps
typedef enum logic [3:0] {LS0=0, LS1=1, LS2=2, LS3=3, LS4=4, LS5=5, LS6=6, LS7=7,OPEN=8, ALARM=9, INIT=10} state_t;

module tb_fsm;
logic clk, rst;
logic [31:0] seq; // 32-bit sequence (8dig x 4bits)
logic [4:0] keyout; // match/submit/confirm button
logic [3:0] state; // state output
logic strbout, exp_strb;
state_t current_state;
logic [19:0]in;
logic [4:0] exp_out, out;
logic [3:0] exp_state;
logic [31:0] sr_out; // 32-bit sequence_sr output (8dig x 4bits)

always
begin
    clk = 0;
    #5;
    clk = ~clk;
    #5;
end

//synckey sync1 (.clk(clk), .rst(rst), .in(in), .out(keyout), .strbout(strbout));
//diglock dlock0 (.clk(clk), .rst(rst), .seq(seq), .keyout(keyout), .state(state));

// synckey ex1 (.clk(clk), .rst(rst), .in(in[19:0]), .out(out), .strbout(strbout));
fsm fsm1 (.clk(clk), .rst(rst), .keyout(keyout), .seq(seq), .state(current_state));

// sequence_sr seqsr  (.clk(clk), .rst(rst), .en(strbout), .in(out[4:0]), .out(sr_out[31:0]));

    task toggle_reset();
        rst = 1;  
        #10;
        rst = 0;  
        #10;
    endtask

    task chk_strb();
        if (rst == 1)
        #10;
        exp_strb = 1;
        #10;
    endtask

    task init_ls0();
    if(rst == 0)
        #10;
        seq = 32'h1;
        #10;
        seq = 32'h12;
        #10;
        seq = 32'h123;
        #10;
        seq = 32'h1234;
        #10;
        seq = 32'h12345;
        #10;
        seq = 32'h123456;
        #10;
        seq = 32'h1234567;
        #10;
        seq = 32'h12345678;
        #10;
        keyout=5'd16;
    endtask 

    task ls0_open();
    if(rst == 0)
        #10;
        keyout=5'h1;
        #10;
        keyout=5'h2;
        #10;
        keyout=5'h3;
        #10;
        keyout=5'h4;
        #10;
        keyout=5'h5;
        #10;
        keyout=5'h6;
        #10;
        keyout=5'h7;
        #10;
        keyout=5'h8;
        #10;
    endtask

    task lock_again();
    #10;    
    keyout=5'd16; //locks again after open 
    #10;
    endtask

    task alarm();
        #10;
        keyout=5'h1;
        #10;
        keyout=5'h2;
        #10;
        keyout=5'h3;
        #10;
        keyout=5'h6; //wrong sequence
        #10;
    endtask

    task hard_reset();
    #10;
    toggle_reset();
    endtask

    task soft_reset();
        #10;
        keyout=5'h1;
        #10;
        keyout=5'h2;
        #10;
        keyout=5'h3;
        #10;
        keyout=5'd16; //w button
        #10;
    endtask

    task post_op();
        #10;
        keyout=5'h1;
        #10;
        keyout=5'h2;
        #10;
        keyout=5'h3;
        #10;
        toggle_reset();
    endtask

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_fsm);
    #10;

    //regular operation:
    toggle_reset(); //reset after each input
    $display("TGL_RST: exp_state = 4'hA, state= %h", state );
    if(state != 4'hA)
        $display("error: exp_state doesn't match state");
    init_ls0();
    $display("INIT_LS0: exp_state = 4'h0, state= %h", state );
    if(state != 4'h0)
        $display("error: exp_state doesn't match state");
    ls0_open();
    $display("LS0_OPN: exp_state = 4'h8, state= %h", state );
    if(state != 4'h8)
        $display("error: exp_state doesn't match state");
    lock_again();
    $display("LOCK: exp_state = 4'h0, state= %h", state );
    if(state != 4'h0)
        $display("error: exp_state doesn't match state");
    alarm();
    $display("ALARM: exp_state = 4'h9, state= %h", state );
    if(state != 4'h9)
        $display("error: exp_state doesn't match state");
    hard_reset();
    $display("HARD_RESET: exp_state = 4'hA, state= %h", state );
    if(state != 4'hA)
        $display("error: exp_state doesn't match state");
    init_ls0();
    soft_reset();
    $display("SOFT_RESET: exp_state = 4'h0, state= %h", state );
    if(state != 4'h0)
        $display("error: exp_state doesn't match state");
    post_op();
    $display("POST_OP: exp_state = 4'hA, state= %h", state );
    if(state != 4'hA)
        $display("error: exp_state doesn't match state");
    //finish the simulation
    #1
    $finish;
end
endmodule
