typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES;

module sound_generator
#(
    parameter N = 7
)
(
    input logic clk, nRst, goodColl_i, badColl_i, buttonPressed_i,
    input logic [3:0] direction_i,
    output logic [N - 1:0] dacCount
);

logic [8:0] freq;
logic goodColl, badColl, button;
logic [3:0] direction;
logic playSound;
logic at_max;
MODE_TYPES mode_o;

pos_detector posDet (.goodColl(goodColl), .badColl(badColl), .button(button), .direction(direction), .clk(clk), .nRst(nRst), .goodColl_i(.goodColl_i), .badColl_i(badColl_i), .button_i(button_i), .direction_i(direction_i));
freq_selector freqSel (.freq(freq), .goodColl_i(goodColl_i), .badColl_i(badColl_i), .direction_i(direction_i));
sound_fsm fsm1 (.playSound(playSound), .mode_o(mode_o), .clk(clk), .nRst(nRst), .goodColl(goodColl), .badColl(badColl), .button(button), .direction(direction));
oscillator osc1 (.at_max(at_max), .clk(clk), .nRst(nRst), .freq(freq), .state(mode_o), .playSound(playSound));
dac_counter dac1 (.dacCount(dacCount), .clk(clk), .nRst(nRst), .at_max(at_max));
endmodule
