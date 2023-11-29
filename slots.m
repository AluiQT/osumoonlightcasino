function slots(balance, casinoEnter, entercasinoSplash, entercasinoForeground)

slotsScene = simpleGameEngine('slotsframes.png',50,50,2);
slotsBg = ones(17,13);
%Create the foreground using index 285(transparent) 
slotsFg = 285 * ones(size(slotsBg));
%Indices of possible lines

%counter to generate the background
counter = 1;

%load sounds here
[yItem,fsItem] = audioread("itembox.mp3");
slotSpinSFX = audioplayer(yItem,fsItem); %Object of the audio file to call
[yPull,fsPull] = audioread("lever.mp3");
leverPullSFX = audioplayer(yPull,fsPull);
[yWin,fsWin] = audioread("wonslots.mp3");
slotWinSFX = audioplayer(yWin,fsWin);

for i = 1:17
    for j = 1:13
        slotsBg(i, j) = counter;
        counter = counter + 1;
        if j == 13
            counter = counter + 2;
        end
    end
end

%Start the game loop
while 1
    %Call balance window function to draw the balance through the
    %foreground
    slotsFg = balanceWindow(slotsScene, slotsBg,slotsFg,balance);
    %Draw the initial scene
    drawScene(slotsScene, slotsBg,slotsFg);
    %Look for mouse inputs
    [xSlots,ySlots] = getMouseInput(slotsScene);
    %If you click on row 1 column 1 go back to the game selector
    if xSlots == 1 && ySlots == 1
        %Close the figure to switch screens
        close;
        %Call the update to switch screens
        updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
        %Break to end the loop
        break
    end
    %This is the area where the lever can be pulled (only let it pulled
    %when balance is available to spin.
    if (xSlots == 5 || xSlots == 6) && (ySlots == 2 || ySlots == 3) && balance >= 100
        %Play the lever pull sound
        play(leverPullSFX)
        %Call the lever pull animation
        leverPull(slotsScene, slotsBg,slotsFg)
        %For now every spin takes away 100 creds
        balance = balance - 100;
        %Call the balance window to update after a spin
        slotsFg = balanceWindow(slotsScene, slotsBg,slotsFg,balance);
        %Calls function that handles the spin animation and bet payout
        [balance,slotsFg] = slotsSpin(slotsScene, slotsBg, slotsFg,slotSpinSFX,balance,slotWinSFX);
    end
end

%Function that handles the spin animation and bet payout
    function [balance,slotsFg] = slotsSpin(slotsScene, slotsBg, slotsFg,slotSpinSFX,balance,slotWinSFX)
    %Plays the slot music
    play(slotSpinSFX);
    start_time = tic;
    %tic/toc is used to make a while loop last for a specfic amount of time
    %this starts the spinning animation
    while toc(start_time) < 2.5
        for i = 256:259
            slotsFg(6, 5) = 256; %Each 3 represent the 3 wheels and represent a spin animation.
            slotsFg(6, 7) = 257;
            slotsFg(6, 9) = 258;
            drawScene(slotsScene, slotsBg, slotsFg);
            pause(0.1);
            slotsFg(6, 5) = 257;
            slotsFg(6, 7) = 258;
            slotsFg(6, 9) = 259;
            drawScene(slotsScene, slotsBg, slotsFg);
            pause(0.1);
            slotsFg(6, 5) = 258;
            slotsFg(6, 7) = 259;
            slotsFg(6, 9) = 256;
            drawScene(slotsScene, slotsBg, slotsFg);
            pause(0.1);
            slotsFg(6, 5) = 259;
            slotsFg(6, 7) = 256;
            slotsFg(6, 9) = 257;
            drawScene(slotsScene, slotsBg, slotsFg);
            pause(0.1);
        end
    end
    %Random integer generator from 256:259 of size 3 to create the slot options
    slotDisplay = randi([256,259],3);
    %Display each option in its respective wheel
    slotsFg(6,5) = slotDisplay(1);
    slotsFg(6,7) = slotDisplay(2);
    slotsFg(6,9) = slotDisplay(3);  
    drawScene(slotsScene, slotsBg, slotsFg);
    %If a=b b=c a=c logic to determine if every number in slotDisplay is
    %equal
    if slotDisplay(1) == slotDisplay(2) && slotDisplay(2) == slotDisplay(3)
        pause(0.8)
        play(slotWinSFX)
        for z = 1:3 %Coin animation for if you win
            slotsFg(6,5) = 260;
            slotsFg(6,7) = 260;
            slotsFg(6,9) = 260; 
            drawScene(slotsScene, slotsBg, slotsFg);
            pause(0.5)
            slotsFg(6,5) = 285;
            slotsFg(6,7) = 285;
            slotsFg(6,9) = 285; 
            drawScene(slotsScene, slotsBg, slotsFg);
            pause(0.5)
        end
        if slotDisplay(1) == 256 || slotDisplay(1) == 257 || slotDisplay(1) == 258
            balance = balance + 500; %Add 500 to your balance if you win
            slotsFg = balanceWindow(slotsScene, slotsBg,slotsFg,balance); %Redraw the balance window
        elseif slotDisplay(1) == 259
            balance = balance + 1000; %Add 1000 to your balance if you win
            slotsFg = balanceWindow(slotsScene, slotsBg,slotsFg,balance); %Redraw the balance window
        end
    end
    pause(0.5) 
end

%Function that updates the balance window
function slotsFg = balanceWindow(slotsScene, slotsBg,slotsFg,balance)
    %Done to make the balance in a XXXXX format with leading 0s
    formattedBalance = sprintf('%05d', balance); 
    for i = 1:5 %262 is the index of 0 (some logic to display the numbers)
        slotsFg(17,i+6) = 262 + str2double(formattedBalance(i));
    end
    %Redraw the scene
    drawScene(slotsScene, slotsBg,slotsFg);
end

function leverPull(slotsScene, slotsBg,slotsFg)
    slotsBg(5,2) = 74;
    slotsBg(5,3) = 75;
    slotsBg(6,2) = 89;
    slotsBg(6,3) = 90;
    drawScene(slotsScene, slotsBg, slotsFg);
    pause(0.2)
    slotsFg(5,2) = 164;
    slotsFg(5,3) = 165;
    slotsFg(6,2) = 179;
    slotsFg(6,3) = 180;
    slotsFg(7,2) = 194;
    slotsFg(7,3) = 195;
    slotsFg(8,2) = 209;
    slotsFg(8,3) = 210;
    slotsFg(9,2) = 224;
    slotsFg(9,3) = 225;
    drawScene(slotsScene, slotsBg, slotsFg);
    pause(0.5)
end

end