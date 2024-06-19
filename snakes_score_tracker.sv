module score_tracker(
    input logic clk, nRst, goodColl, badColl,
    output logic [6:0] currScore, highScore,
    output logic isGameComplete
);
    logic [6:0] nextCurrScore, nextHighScore, maxScore;
    assign maxScore = 100;
   
    always_ff @(posedge clk, negedge nRst) begin
        if (~nRst) begin
            currScore <= 7'b0;
            highScore <= 7'b0;
        end else begin
            currScore <= nextCurrScore;
            highScore <= nextHighScore;
        end
    end

    always_comb begin
        nextCurrScore = currScore;
        isGameComplete = 1'b0;
        nextHighScore = highScore;
        if (goodColl) begin
            nextCurrScore = currScore + 1;
            if (currScore > highScore) begin
                nextHighScore = currScore;
            end
        end
        if (badColl || currScore >= maxScore) begin
            nextCurrScore = 0;
            isGameComplete = 1'b1;
        end
    end
endmodule
