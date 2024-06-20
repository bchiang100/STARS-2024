// THIS MODULE CONTAINS THE POSITIVE EDGE DETECTOR, FSM LOGIC, AND FREQUENCY SELECTOR LOGIC

typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES;

module sound_fsm(
    input logic clk, nRst, goodColl, badColl, buttonPressed,
    input logic [3:0] direction,
    output logic playSound,
    output logic [8:0] freq,
    output MODE_TYPES mode_o // current state
);
logic newGoodColl, newBadColl;
logic [3:0] newDirection;


MODE_TYPES next_state;

// Positive Edge Detector
always_ff @(posedge clk) begin
    newGoodColl <= goodColl;
    newBadColl <= badColl;
    newDirection <= direction;
end
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        mode_o <= ON;
    end else begin
        mode_o <= next_state;
    end
end

always_comb begin
    playSound = 1'b0;
    next_state = mode_o;
    case (mode_o)
        ON:
            if (buttonPressed) begin
                next_state = OFF;
            end
            else if (newGoodColl || newBadColl || |newDirection) begin
                playSound = 1'b1;
            end
        OFF:
            if (buttonPressed) begin
                next_state = ON;
            end
    endcase
end

// Frequency Selector
always_comb begin
    freq = 0;
    if (goodColl)
        freq = 440; // A
    if (badColl)
        freq = 311; // D Sharp
    if (|direction)
        freq = 262; // C
end
endmodule

