function roulette(casinoEnter, entercasinoSplash, entercasinoForeground,balance)

%Roulette SDP

%Initialize the game scene using the 'simpleGameEngine' function
rouletteScene = simpleGameEngine('iloveit.png',66,50,1);

%%Create the GUI
row3 = 1:3:36;
row2 = 2:3:36;
row1 = 3:3:36;
clearTile = 71;

% Define special rows for 2-to-1 bets, zero, and the twelves
twotoone = [37; 38; 39];
zero = [40;41;42];
twelves = [67,43:54,67];

%fifth row
row5 = [67,55:66,67];

%combine the rows to create the roulette table
baka = vertcat(row1, row2, row3);
baka = horzcat(zero, baka, twotoone);
baka = vertcat(baka, twelves, row5);

%create empty greenspace for gui
greenspace = [];
for i = 1:14
    greenspace = [greenspace, 67];
end

%Concat to create the gui
greenspace = vertcat(greenspace,greenspace,greenspace,greenspace,greenspace);
gui = vertcat(greenspace,baka);
gui = horzcat([greenspace;greenspace],gui);

%Create a reset button
gui(1,26) = 73;
gui(1,27) = 74;
gui(1,28) = 75;

%Create the balance counter
gui(10,1) = 76;
gui(10,2) = 77;
gui(10,3) = 78;
gui(10,4) = 79;

%Set the foreground to transparent
foreground = clearTile * ones(size(gui));

% Create a 7 x 9 matrix for the size of the roulette wheel
wheel = zeros(7, 9);

%Fill the matrix from right to left with numbers 80 to 143 representing
%the spritesheet index of the wheel
counter = 80;
for row = 1:7
    for col = 1:9
        wheel(row, col) = counter;
        counter = counter + 1;
    end
end

%Back button to the casino update scene
gui(1,1) = 213;

%Set this part of the GUI to the wheel
gui(2:8, 4:12) = wheel;

%Create the window that displays bet information
window = ones(2, 12);
window(1,:) = 192;
window(2,:) = 193;
window(1,1) = 188;
window(2,1) = 190;
window(1,2) = 189;
window(2,2) = 191;
window(1:2,3) = 67;
window(1,4) = 188;
window(2,4) = 190;
window(1,12) = 189;
window(2,12) = 191;


gui(3:4,16:27) = window;
foreground(4,16) = 194;
foreground(4,17) = 194;

%Create a balance window
gui(10,5) = 204;
gui(10,6:8) = 205;
gui(10,9) = 206;
foreground(10,5:9) = 194;

%Create a spin wheel button
foreground(9,7) = 207;
foreground(9,8) = 208;
foreground(9,9) = 209;
gui(9,7) = 210; %This part is to make the neat "push" effect :D
gui(9,8) = 211;
gui(9,9) = 212;

%Set everything besides the index of the roulette table to 727 (arbitrary
%number), this is designed to handle my betting logic
betCounter = 727 * ones(size(foreground));

% Create a logical mask to track bets by only setting sprites that are in
% the bet table indices to 0
for i = 1:10
    for j = 1:28
        if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
            betCounter(i,j) = 0;
        end
    end
end

%Relevant audio files will go below here

% Read the MP3 file
[y, Fs] = audioread('robloxWin.mp3'); %Audio file for when your bet hits.
[y2, Fs2] = audioread('tromboneSad.mp3'); %Audio file for when your bet fails.
[y3, Fs3] = audioread('rouletteBallSound.mp3'); %Audio file for roulette spin animation.
[yDrop,FsDrop] = audioread('chipdrop.mp3'); %Audio file for placing a chip down.
[yButton,FsButton] = audioread('pressbutton.mp3'); %Audio file for pressing a button.

% Create an audioplayer object for each individual audio
robloxWin = audioplayer(y, Fs); 
tromboneSad = audioplayer(y2,Fs2); 
rouletteEffect = audioplayer(y3,Fs3);
chipDrop = audioplayer(yDrop,FsDrop);
pressButton = audioplayer(yButton,FsButton);
amountbet = 0; %This will track amount bet during each play
foreground = balanceButton(foreground,balance); %Sets the beginning balance onto the counter
%Start the game loop

%While 1 will run forever (until manually terminated.)
while 1
       drawScene(rouletteScene,gui,foreground)
       %Register mouse input for chip bets
       [x,y] = getMouseInput(rouletteScene);  
       %Conditional which checks if max bet has been reached on a square
       %and if you clicked on the betting table. Only allowed to bet if
       %you have a balance greater than 0.
       if balance > 0 && ~isnan(x) && ~isnan(y) && betCounter(x,y) < 3
            betCounter(x, y) = mod(betCounter(x, y) + 1, 4); % Cycles through 0, 1, 2, 3
            %Play chip drop noise
            play(chipDrop)
            %Update foreground based on the bet counter
            foreground(x, y) = 67 + betCounter(x, y);
            %Reset the mouse input
            x = NaN;
            y = NaN;
            %Subtract from the bet from the balance.
            balance = balance - 100;
            %Update balance counter
            foreground = balanceButton(foreground,balance);
       end
       %Conditional to check if you clicked the spin button
       if x == 9 && (y == 7|| y == 8 || y == 9)
           %Play the press button audio
           play(pressButton)
           %Simulate a button press (animation purposes)
           buttonpress(rouletteScene,gui,foreground,clearTile)
           %Generate a random integer to represent the numbers on the wheel
           randomNumber = randi([0, 36]);
           %Call the wheel spin animation (function)
           wheelSpin(rouletteScene,gui,foreground, rouletteEffect,randomNumber)
           % Reset only the betting table part of the foreground
            for i = 1:10
                for j = 1:28
                    if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
                        foreground(i, j) = 71;
                    end
                end
            end
           %Call the function which handles winning and betting logic
           winnings = betLogic(randomNumber, gui, betCounter, robloxWin, tromboneSad, amountbet);
           amountbet = 0;
           %Change the window display to the number 
           foreground = windowDisplay(foreground,randomNumber);
           
            % Generate the filename based on the random index
           numberAudio = sprintf('voicenumbers/voice%02d.mp3', randomNumber);
           pause(1);
           % Load and play the selected audio file
           [yVoice, fsVoice] = audioread(numberAudio);
            voiceAudio = audioplayer(yVoice,fsVoice);
            play(voiceAudio)


           %Update the balance with winnings.
           balance = balance + winnings;
           %Loop through the gui matrix for the indices of the betting
           %table and set the corresponding counter of each back to 0.
           for i = 1:10
                for j = 1:28
                     if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
                         betCounter(i,j) = 0;
                     end
                 end
           end
           foreground = balanceButton(foreground,balance);

       end
       %Check if back button is pressed
       if x == 1 && y == 1
           %Loop through the gui matrix for the indices of the betting
           %table and set the corresponding counter of each back to 0.
           for i = 1:10
                for j = 1:28
                     if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
                          balance = balance + betCounter(i,j) * 100; %This refunds the balance by checking each counter.
                          betCounter(i,j) = 0;
                     end
                 end
           end
           close;
           updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
           break;
       end
       %Conditional to check if you clicked the reset bet button
       if x == 1 && (y == 26 || y == 27 || y == 28)
           %Loop through the gui matrix for the indices of the betting
           %table and set the corresponding counter of each back to 0.
           for i = 1:10
                for j = 1:28
                     if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
                          balance = balance + betCounter(i,j) * 100; %This refunds the balance by checking each counter.
                          betCounter(i,j) = 0;
                     end
                 end
           end
           % Reset only the betting mat part of the foreground
            for i = 1:10
                for j = 1:28
                    if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
                        foreground(i, j) = 71;
                    end
                end
            end
           foreground = balanceButton(foreground,balance);
       end
end

%Function for a cleaner looking loop. Handles bets 
function winnings = betLogic(randomNumber, gui, betCounter, robloxWin, tromboneSad, amountbet)
    winnings = 0;
    %Nested for loop to calculate payouts based on the gui matrices
    for i = 1:10 
        for j = 1:28
            %Calculate counter and winnings for a straight bet (specific
            %number pays out 35:1)
            if gui(i,j) == randomNumber
                winnings = winnings + betCounter(i,j) * 100 * 35;
            elseif gui(i,j) == 37 
            %Calculate counter and winnings for the first row of 2 to 1 bet
            %pays out 3:1                
                if randomNumber >= 3 && randomNumber <= 36 && mod(randomNumber, 3) == 0
                    winnings = winnings + betCounter(i,j) * 100 * 3;            
                end
            %Calculate counter and winnings for the second row of 2 to 1 bet
            %pays out 3:1
            elseif gui(i,j) == 38
                if randomNumber >= 2 && randomNumber <= 35 && mod(randomNumber, 3) == 2
                    winnings = winnings + betCounter(i,j) * 100 * 3;  
                end
            %Calculate counter and winnings for the third row of 2 to 1 bet
            %pays out 3:1
            elseif gui(i,j) == 39
                if randomNumber >= 2 && randomNumber <= 35 && mod(randomNumber, 3) == 1
                    winnings = winnings + betCounter(i,j) * 100 * 3; 
                end
            %Calculate counter and winnings for if you bet on green (35:1)
            elseif gui(i,j) == 41
                if randomNumber == 0
                    winnings = winnings + betCounter(i,j) * 100 * 35;
                end
            %Calculate counter and winnings for if you bet on numbers 1-12 (3:1)
            elseif gui(i,j) >= 43 && gui (i,j) <= 46
                if randomNumber >= 1 && randomNumber <= 12
                    winnings = winnings + betCounter(i,j) * 100 * 3;  
                end
            %Calculate counter and winnings for if you bet on numbers 13-24 (3:1)
            elseif gui(i,j) >= 47 && gui (i,j) <= 50
                if randomNumber >= 13 && randomNumber <= 24
                    winnings = winnings + betCounter(i,j) * 100 * 3;  
                end
            %Calculate counter and winnings for if you bet on numbers 25-36 (3:1)
            elseif gui(i,j) >= 51 && gui (i,j) <= 54
                if randomNumber >= 25 && randomNumber <= 36
                    winnings = winnings + betCounter(i,j) * 100 * 3;  
                end
            %Calculate counter and winnings for if you bet on numbers 1-18 (2:1)
            elseif gui(i,j) == 55 || gui(i,j) == 56
                if randomNumber >= 1 && randomNumber <= 18
                    winnings = winnings + betCounter(i,j) * 100 * 2;  
                end
            %Calculate counter and winnings for if you bet on numbers 19-36 (2:1)
            elseif gui(i,j) == 65 || gui(i,j) == 66
                if randomNumber >= 19 && randomNumber <= 36
                    winnings = winnings + betCounter(i,j) * 100 * 2;  
                end
            %Calculate counter and winnings for if you bet on the even numbers (excluding zero) (2:1)
            elseif gui(i,j) == 57 || gui(i,j) == 58
                if mod(randomNumber, 2) == 0 && randomNumber ~= 0
                    winnings = winnings + betCounter(i,j) * 100 * 2;  
                end
            %Calculate counter and winnings for if you bet on the odd
            %numbers 2:1
            elseif gui(i,j) == 63 || gui(i,j) == 64
                if mod(randomNumber, 2) == 1 
                    winnings = winnings + betCounter(i,j) * 100 * 2; 
                end
            %Calculate counter and winnings for if you bet on red numbers
            %This calls the function getRouletteColor to check for clearer
            %code. 2:1
            elseif gui(i,j) == 59 || gui(i,j) == 60
                if strcmp(getRouletteColor(randomNumber),'red')
                    winnings = winnings + betCounter(i,j) * 100 * 2; 
                end
            %Calculate counter and winnings for if you bet on black numbers
            %This calls the function getRouletteColor to check for clearer
            %code. 2:1
            elseif gui(i,j) == 61 || gui(i,j) == 62
                if strcmp(getRouletteColor(randomNumber),'black')
                    winnings = winnings + betCounter(i,j) * 100 * 2; 
                end
            end   
        end
    end
    %Calculate amount bet for sound fx
    for i = 1:10
        for j = 1:28
            if gui(i,j) >= 1 && gui(i,j) <= 66 && gui(i,j) ~= 40 && gui(i,j) ~= 42
                amountbet = amountbet + betCounter(i,j);
            end
        end
    end
    %Play audio depending on if you had winnings or not 
    if winnings > (amountbet * 100)
        play(robloxWin)
    elseif winnings < (amountbet * 100)
        play(tromboneSad)
    end
end

%Function for determining number to color
function color = getRouletteColor(number)
    %The pattern for black colors on a roulette table is not
    %straightforward but we can generalize areas for cleaner code.
    if (number >= 1 && number <= 10 && mod(number, 2) == 0) || ...
       (number >= 19 && number <= 28 && mod(number, 2) == 0) || ...
       (number >= 11 && number <= 18 && mod(number, 2) == 1) || ...
       (number >= 29 && number <= 36 && mod(number, 2) == 1)
        color = 'black';
    else
        color = 'red';
    end
end

%Wheel spin (not able to use a loop because of how not ordered the pixels are :(( ) 
%DO NOT SLOW THE WHEEL DOWN THE BALL WILL LOOK WONKY
function wheelSpin(rouletteScene,gui,foreground, rouletteEffect,randomNumber)
    spinTime = 0.001;
    pause(1); %Used just to delay operations incase of performance issues
    play(rouletteEffect)
    for i = 1:7 %The number comments are used to keep track of each drawing of the ball
        %it is hard to generalize this so brute forcing is the only way
        %(unless I'm stupid.)
        foreground(3,8) = 143; %1
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 0
            break
        end
        pause(spinTime); %2
        foreground(3,8) = 144;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 32
            break
        end
        pause(spinTime); %3
        foreground(3,8) = 71;
        foreground(3,9) = 145;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 15
            break
        end
        pause(spinTime); %4
        foreground(3,9) = 71;
        foreground(4,9) = 146;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 19
            break
        end
        pause(spinTime); %5
        foreground(4,9) = 147;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 4
            break
        end
        pause(spinTime); %6
        foreground(4,9) = 71;
        foreground(4,10) = 148;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 21
            break
        end
        pause(spinTime) %7
        foreground(4,10) = 149;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 2
            break
        end
        pause(spinTime) %8
        foreground(4,10) = 150;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 25
            break
        end
        pause(spinTime) %9
        foreground(4,10) = 71;
        foreground(5,10) = 151;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 17
            break
        end
        pause(spinTime) %10
        foreground(5,10) = 152;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 34
            break
        end
        pause(spinTime) %11
        foreground(5,10) = 153;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 6
            break
        end
        pause(spinTime) %12
        foreground(5,10) = 154;
        foreground(6,10) = 155;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 27
            break
        end
        pause(spinTime) %13
        foreground(5,10) = 71;
        foreground(6,10) = 156;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 13
            break
        end
        pause(spinTime) %14
        foreground(6,10) = 157;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 36
            break
        end
        pause(spinTime) %15
        foreground(6,10) = 71;
        foreground(6,9) = 158;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 11
            break
        end
        pause(spinTime) %16
        foreground(6,9) = 159;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 30
            break
        end
        pause(spinTime) %17
        foreground(6,9) = 160;
        foreground(7,9) = 161;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 8
            break
        end
        pause(spinTime) %18
        foreground(6,9) = 71;
        foreground(7,9) = 162;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 23
            break
        end
        pause(spinTime) %19
        foreground(7,9) = 71;
        foreground(7,8) = 163;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 10
            break
        end
        pause(spinTime) %20
        foreground(7,8) = 164;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 5
            break
        end
        pause(spinTime) %21
        foreground(7,7) = 165;
        foreground(7,8) = 166;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 24
            break
        end
        pause(spinTime) %22
        foreground(7,8) = 71;
        foreground(7,7) = 167;
        foreground(6,7) = 168;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 16
            break
        end
        pause(spinTime) %23
        foreground(7,7) = 71;
        foreground(6,7) = 169;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 33
            break
        end
        pause(spinTime) %24
        foreground(6,7) = 170;
        foreground(6,6) = 171;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 1
            break
        end
        pause(spinTime) %25
        foreground(6,7) = 71;
        foreground(6,6) = 172;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 20
            break
        end
        pause(spinTime) %26
        foreground(6,6) = 173;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 14
            break
        end
        pause(spinTime) %27
        foreground(6,6) = 174;
        foreground(5,6) = 175;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 31
            break
        end
        pause(spinTime) %28
        foreground(6,6) = 71;
        foreground(5,6) = 176;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 9
            break
        end
        pause(spinTime) %29
        foreground(5,6) = 177;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 22
            break
        end
        pause(spinTime) %30
        foreground(5,6) = 178;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 18
            break
        end
        pause(spinTime) %31
        foreground(5,6) = 71;
        foreground(4,6) = 179;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 29
            break
        end
        pause(spinTime) %32
        foreground(4,6) = 180;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 7
            break
        end
        pause(spinTime) %33
        foreground(4,6) = 181;
        foreground(4,7) = 182;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 28
            break
        end
        pause(spinTime) %34
        foreground(4,6) = 71;
        foreground(4,7) = 183;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 12
            break
        end
        pause(spinTime) %35
        foreground(4,7) = 184;
        foreground(3,7) = 185;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 35
            break
        end
        pause(spinTime) %36
        foreground(4,7) = 71;
        foreground(3,7) = 186;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 3
            break
        end
        pause(spinTime) %36
        foreground(3,7) = 71;
        foreground(3,8) = 187;
        drawScene(rouletteScene,gui,foreground)
        if i == 7 && randomNumber == 26
            break
        end
        pause(spinTime)
    end
    pause(2)
end

%Function that updates the window displaying which number was landed
function foreground = windowDisplay(foreground,randomNumber)
    num = sprintf('%02d', randomNumber); %Used to convert any single digit number to 'x' to '0x' to display
    foreground(4, 16) = 194 + str2double(num(1)); %Sets the window number to the first digit of the random number
    foreground(4, 17) = 194 + str2double(num(2)); %Sets the window number to the second digit of the random number
end

%This creates the balance button
function foreground = balanceButton(foreground,balance)
    % Convert balance to a string with leading zeros and fixed width (5
    % digits) will break if the player makes too much money (unlikely,
    % welcome to the casino baby)
    formattedBalance = sprintf('%05d', balance); %See line 579
    for i = 1:5
        %Use math to relate the foreground position to the balance number
        foreground(10,i+4) = 194 + str2double(formattedBalance(i));
    end
end


%This is a neat button press animation function because I have too much time on
%My hands
function buttonpress(rouletteScene,gui,foreground,clearTile)
    foreground(9,7) = clearTile;
    foreground(9,8) = clearTile;
    foreground(9,9) = clearTile;
    drawScene(rouletteScene,gui,foreground)
    %This pauses everything for 0.2 seconds so the button press will show
    pause(0.2)
    foreground(9,7) = 207;
    foreground(9,8) = 208;
    foreground(9,9) = 209;
    drawScene(rouletteScene,gui,foreground)
end
%If you made it through all the comments I'm proud of you.
end
