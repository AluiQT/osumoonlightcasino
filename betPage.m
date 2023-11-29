function [betScreen, userBet] = betPage(balance)
betPageArray = [1:10; 11:20; 21:30; 31:40; 41:50; 51:60; 61:70; 71:80; 81:90; 91:100];

aThruJ = betPageArray(1,:);
kThruT = betPageArray(2,:);
uThruZ = betPageArray (3, 1:6);
dots = betPageArray(4,1:3);

redNumbers = betPageArray(9,:);
whiteNumbers = betPageArray(10,:);

blankSpace = betPageArray(8,9);
blankRow = ones(1,11) * blankSpace; 
graySpace = betPageArray(4,1);
halfGrayRow = [blankSpace, blankSpace, blankSpace, graySpace, graySpace, graySpace, graySpace, graySpace, blankSpace, blankSpace, blankSpace];
grayRow = ones(1,11) * graySpace;

% M, A, X,  , O, F,  , 1, 0, 0, 0
maxOf1000 = [kThruT(3), aThruJ(1), uThruZ(4), blankSpace, kThruT(5), aThruJ(6), blankSpace, redNumbers(1,1), redNumbers(1,10), redNumbers(1,10), redNumbers(1,10)];

% E, N, T, E, R
enterButton = [blankSpace, blankSpace, blankSpace, aThruJ(5), kThruT(4), kThruT(10), aThruJ(5), kThruT(8), blankSpace, blankSpace, blankSpace];

% NUMBER PAD (1,2,3,4; 5,6,7,8; 9)
oneThruFour = [blankSpace, blankSpace, whiteNumbers(1), blankSpace, whiteNumbers(2), blankSpace, whiteNumbers(3), blankSpace, whiteNumbers(4), blankSpace, blankSpace];
fiveThruEight = [blankSpace, blankSpace, whiteNumbers(5), blankSpace, whiteNumbers(6), blankSpace, whiteNumbers(7), blankSpace, whiteNumbers(8), blankSpace, blankSpace];
soleNine = [blankSpace, blankSpace, blankSpace, blankSpace, whiteNumbers(9), blankSpace, whiteNumbers(10), blankSpace, blankSpace, blankSpace, blankSpace];


%Blank Array used for user bet input
% userBetArray is used for creating a graphic
% userNumArray is used for creating the numerical value
userBetArray = [blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace];
userNumArray = [];

%Configuration of Screen
screenConfig = [maxOf1000; blankRow; userBetArray; blankRow; blankRow; oneThruFour; blankRow; fiveThruEight; blankRow; soleNine; blankRow; blankRow; enterButton];
backgroundConfig = [grayRow; blankRow; blankRow; blankRow; blankRow; blankRow; blankRow; blankRow; blankRow; blankRow; blankRow; blankRow; halfGrayRow];

betScreen = simpleGameEngine('betImage.png',9,9,15,[179,138,255]);
drawScene(betScreen, backgroundConfig, screenConfig)

%Loop control variable and index value for some parts of loop
i=1;
flag = true;

while(flag)
    mistake = false;
    fail = false;
    [xCoordinate, yCoordinate] = getMouseInput(betScreen);

    %creating image of user chosen bet
    if (xCoordinate == 6) && (yCoordinate == 3)
        userBetArray(i+4) = whiteNumbers(1);
        userNumArray(i) = 1;

    elseif (xCoordinate == 6) && (yCoordinate == 5)
        userBetArray(i+4) = whiteNumbers(2);
        userNumArray(i) = 2;

    elseif (xCoordinate == 6) && (yCoordinate == 7)
        userBetArray(i+4) = whiteNumbers(3);
        userNumArray(i) = 3;

    elseif (xCoordinate == 6) && (yCoordinate == 9)
        userBetArray(i+4) = whiteNumbers(4);
        userNumArray(i) = 4;

    elseif (xCoordinate == 8) && (yCoordinate == 3)
        userBetArray(i+4) = whiteNumbers(5);   
        userNumArray(i) = 5;

    elseif (xCoordinate == 8) && (yCoordinate == 5)
        userBetArray(i+4) = whiteNumbers(6);  
        userNumArray(i) = 6;

    elseif (xCoordinate == 8) && (yCoordinate == 7)
        userBetArray(i+4) = whiteNumbers(7);   
        userNumArray(i) = 7;

    elseif (xCoordinate == 8) && (yCoordinate == 9)
        userBetArray(i+4) = whiteNumbers(8);    
        userNumArray(i) = 8;

    elseif (xCoordinate == 10) && (yCoordinate == 5)
        userBetArray(i+4) = whiteNumbers(9);    
        userNumArray(i) = 9;

    elseif (xCoordinate == 10) && (yCoordinate == 7)
        userBetArray(i+4) = whiteNumbers(10);
        userNumArray(i) = 0;

    elseif (xCoordinate == 13) && (yCoordinate == 4 || 5 || 6 || 7 || 8)
        userBet = sscanf(sprintf('%d', userNumArray), '%f');
        if isempty(userBet)
            userBet = 0;
        end

        if (userBet <= 1000) && (userBet > 0)
            flag = false;
            break;
   
        elseif (userBet == 0)
            mistake = true;
        end
    else
        i= i-1;
        [xCoordinate, yCoordinate] = getMouseInput(betScreen);

    end

    
    
    screenConfig = [maxOf1000; blankRow; userBetArray; blankRow; blankRow; oneThruFour; blankRow; fiveThruEight; blankRow; soleNine; blankRow; blankRow; enterButton];
    drawScene(betScreen, backgroundConfig, screenConfig)    
    
    %https://www.mathworks.com/matlabcentral/answers/379997-how-to-append-several-elements-to-a-single-element-in-an-array
    %The website above was used for the code below - sscanf(sprintf(..))
    userBet = sscanf(sprintf('%d', userNumArray), '%f');
    if(i == 4)
        if (userBet <= 1000)
            flag = false;

        elseif (isempty(userBet))
            mistake = true;
            
        else
            %Show incorrect bet
            screenConfig = [maxOf1000; blankRow; userBetArray; blankRow; blankRow; oneThruFour; blankRow; fiveThruEight; blankRow; soleNine; blankRow; blankRow; enterButton];
            drawScene(betScreen, backgroundConfig, screenConfig) 
            pause(0.3);
            %Clear inputted bet
            userBetArray = [blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace, blankSpace];
            screenConfig = [maxOf1000; blankRow; userBetArray; blankRow; blankRow; oneThruFour; blankRow; fiveThruEight; blankRow; soleNine; blankRow; blankRow; enterButton];
            drawScene(betScreen, backgroundConfig, screenConfig)
            userNumArray = [];

            userBet = sscanf(sprintf('%d', userNumArray), '%f')
            fail = true;
        end
    end
    
    if (fail)
        i = 1;
    elseif (fail == false) && (flag) && (mistake == false)
        i = i+1;
    elseif (mistake)
        userNumArray = [0];
        userBet = sscanf(sprintf('%d', userNumArray), '%f');
        flag = false;
        break;
    elseif (flag == 0)
        break;
    end
end
if balance < userBet
    userBet = 0;
end
close;
end