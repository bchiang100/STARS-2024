typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES;

module sound_generator
#(
    parameter N = 7
)
(
    input logic clk, nRst, goodColl, badColl, buttonPressed,
    input logic [3:0] direction,
    output logic [N - 1:0] dacCount
);
logic [8:0] freq;
logic playSound;
logic at_max;
MODE_TYPES mode_o;

sound_fsm fsm1 (.playSound(playSound), .mode_o(mode_o), .freq(freq), .clk(clk), .nRst(nRst), .goodColl(goodColl), .badColl(badColl), .buttonPressed(buttonPresed), .direction(direction));
oscillator osc1 (.at_max(at_max), .clk(clk), .nRst(nRst), .freq(freq), .state(mode_o), .playSound(playSound));
dac_counter dac1 (.dacCount(dacCount), .clk(clk), .nRst(nRst), .at_max(at_max));
endmodule
