function [bestOfDisplay, numRounds] = bestOfScreen()
    %Have options 1, 3, 5
    
    bestOfArray = [1:5; 6:10; 11:15; 16:20];
    bestOfScreen = simpleGameEngine('betaBestOf.png',10,10,20,[179,138,255]);
    
    %Specific Sprites
    greenSquare = bestOfArray(3,1);
    bestOfWord = bestOfArray(1,:);
    option1 = bestOfArray(2,1);
    option2 = bestOfArray(2,2);
    option3 = bestOfArray(2,3);
    
    %arrays that create the "rows" in the display
    bestOfDisplayRow1 = [greenSquare, bestOfWord, greenSquare]; %each row is 10x60; 7 elements long
    bestOfDisplayRow2 = [greenSquare, greenSquare, greenSquare, greenSquare, greenSquare, greenSquare, greenSquare];
    bestOfDisplayRow3 = [greenSquare, option1, greenSquare, option2, greenSquare, option3, greenSquare];
    bestOfDisplayRow4 = bestOfDisplayRow2;
    
    %Creation of image
    bestOfDisplay = [bestOfDisplayRow1; bestOfDisplayRow2; bestOfDisplayRow3; bestOfDisplayRow4];
    drawScene(bestOfScreen, bestOfDisplay)
 
    
    %Getting user input on how many rounds they want to play
    [bestOfMouseX, bestOfMouseY] = getMouseInput(bestOfScreen);
    numRounds = 0;

    %Loop control variable for the third while loop
    flag = true;
    
    %if the user chooses 1, 3, or 5 respectively; the while loop continues until a legitimate option is chosen
    while (flag) 
        if (bestOfMouseX == 3) && (bestOfMouseY == 2)
            numRounds = 1;
            flag = false;
        elseif (bestOfMouseX == 3) && (bestOfMouseY == 4)
            numRounds = 3;
            flag = false;
        elseif (bestOfMouseX == 3) && (bestOfMouseY == 6)
            numRounds = 5;
            flag = false;
        else
            [bestOfMouseX, bestOfMouseY] = getMouseInput(bestOfScreen);
        end
    end
    close;
end