/*
    Module Name: tb_border_snakes.sv
    Description: Test bench for border_generator module
*/

`timescale 1ms / 100us

module tb_border_snakes ();

    // Enum for mode types
    typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
    } MODE_TYPES;

    // Testbench parameters
    localparam CLK_PERIOD = 10; // 100 Hz clk
    logic tb_checking_outputs; 
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic [3:0] tb_x, tb_y;
    logic tb_isBorder;

    // Task to check time output
    task check_border;
    input logic exp_isBorder; 
    begin
        
        tb_checking_outputs = 1'b1;
        if(tb_isBorder == exp_isBorder)
            $info("Correct border output: %0d.", exp_isBorder);
        else
            $error("Incorrect mode. Expected: %0d. Actual: %0d.", exp_isBorder, tb_isBorder); 
        
        
        tb_checking_outputs = 1'b0;  
    end
    endtask



    // DUT Portmap
    border_generator DUT(.x(tb_x), .y(tb_y), .isBorder(tb_isBorder)); 

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_x = 4'b0;
        tb_y = 4'b0;
        tb_isBorder = 1'b0;

        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 0: Power-on-Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Check isBorder";
        $display("\n\n%s", tb_test_case);

        tb_x = 4'b0;
        tb_y = 4'b1;

        // Wait for a bit before checking for correct functionality
        #(2);
        check_border(1'b1);
    $finish;
    end;
endmodule
