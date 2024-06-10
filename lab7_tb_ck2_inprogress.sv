`timescale 1ms/10ps

typedef enum logic [3:0] {LS0=0, LS1=1, LS2=2, LS3=3, LS4=4, LS5=5, LS6=6, LS7=7,OPEN=8, ALARM=9, INIT=10} state_t;

module tb_fsm;

logic clk, rst;
logic [4:0] exp_out, out;
logic [31:0] seq, exp_seq;
logic [3:0] exp_state;
state_t current_state;
logic [4:0] keyout;


always
begin
   clk = 0;
   #5;
   clk = ~clk;
   #5;
end

fsm fsm1 (.clk(clk), .rst(rst), .keyout(keyout), .seq(seq), .state(current_state));

   task power_on_reset();
       rst = 1;  
       #10;
       rst = 0;  
       #10;
   endtask


   task press_button();
    for(integer i=1; i<=8; i++) begin
        @(negedge clk);
        keyout = i[4:0];
        
        // case(i)
        //     1:
        //         if (current_state != LS1)
        //             $display("Test %d did not pass", i);
        //     2:
        //         if (current_state != LS2)
        //             $display("Test %d did not pass", i);
        //     3:
        //         if (current_state != LS3)
        //             $display("Test %d did not pass", i);
        //     4:
        //         if (current_state != LS4)
        //             $display("Test %d did not pass", i);
        //     5:
        //         if (current_state != LS5)
        //             $display("Test %d did not pass", i);
        //     6:
        //         if (current_state != LS6)
        //             $display("Test %d did not pass", i);
        //     7:
        //         if (current_state != LS7)
        //             $display("Test %d did not pass", i);
        //     8:
        //         if (current_state != OPEN)
        //             $display("Test %d did not pass", i);
        // endcase

        $display("exp_state = %b, current state= %b", exp_state, current_state);
        if(exp_state != current_state)
            $display("error: exp_state is not the same as the current state");
        exp_state += 4'b1;
    end
   endtask

   task chkvalue(input current_state, exp_state);
    for (integer i = 1; i <= 8; i++) begin
        @(negedge clk);
    $display("exp_state = %b, state= %b", exp_state, current_state);
       if(exp_state != current_state)
           $display("error: exp_state is not the same as the state");
    end
   endtask


initial begin
   $dumpfile("sim.vcd");
   $dumpvars(0, tb_fsm);
   #10;
   keyout=5'b0;
   power_on_reset();
   exp_state = 4'b0;
   seq=32'h12345678;

   @(negedge clk);
   keyout = 5'd16;
   press_button();
   exp_state = OPEN;
   //chkvalue(current_state, exp_state);

   //finish the simulation
   #1
   $finish;
end //begin
endmodule
