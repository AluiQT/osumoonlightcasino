function [opScreen, userDecision2] = optionScreen()
    optionsPageArray = [1:10; 11:20; 21:30; 31:40; 41:50; 51:60; 61:70; 71:80; 81:90; 91:100];
        % A through J is 1:10
        % K through T is 11:20
        % U through Z is 21:26
    
    %Creating blank space and row
    blankSpace = optionsPageArray(9,9);
    blankRow = [blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace];
    
    %Creating gray space and different row lengths
    graySpace = optionsPageArray(4,1);
    grayRow = [blankSpace, graySpace,graySpace,graySpace,graySpace,graySpace,graySpace,graySpace, blankSpace];
    shortGrayRow = [blankSpace, graySpace,graySpace,graySpace,graySpace,graySpace, blankSpace, blankSpace, blankSpace];
    shortestGrayRow = [blankSpace, graySpace,graySpace,graySpace,graySpace, blankSpace, blankSpace, blankSpace, blankSpace];
    
    %Creating words from alphabet sprites
    playWord = [blankSpace, optionsPageArray(2,6), optionsPageArray(2,2), optionsPageArray(1,1), optionsPageArray(3,5), blankSpace, blankSpace, blankSpace, blankSpace]; % P, L, A, Y
    betWord = [blankSpace, optionsPageArray(1,2), optionsPageArray(1,5), optionsPageArray(2,10), blankSpace, blankSpace, blankSpace, blankSpace, blankSpace]; %B, E, T
    bestOfWord = [blankSpace, optionsPageArray(1,2), optionsPageArray(1,5), optionsPageArray(2,9), optionsPageArray(2,10), blankSpace,optionsPageArray(2,5), optionsPageArray(1,6), blankSpace]; %B, E, S, T,  , O, F
    returnWord = [blankSpace, optionsPageArray(2,8), optionsPageArray(1,5), optionsPageArray(2,10), optionsPageArray(3,1), optionsPageArray(2,8), optionsPageArray(2,4), blankSpace, blankSpace]; %R, E, T, U, R, N
    
    %Creating the arrays that configure the screen
    wordConfig = [blankRow; playWord; blankRow; betWord; blankRow; bestOfWord; blankRow; returnWord; blankRow];
    backgroundConfig = [blankRow; shortGrayRow; blankRow; shortestGrayRow; blankRow; grayRow; blankRow; grayRow; blankRow];
    
    %Creating the screen
     opScreen = simpleGameEngine('newLettersAndNumbers.png',9,9,15,[103,58,183]);
     drawScene(opScreen, backgroundConfig, wordConfig)
     userDecision2 = getMouseInput(opScreen);
     close;

end