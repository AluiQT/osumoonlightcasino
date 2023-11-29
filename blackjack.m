function blackjack(balance,casinoEnter, entercasinoSplash, entercasinoForeground)


card_scene = simpleGameEngine('blackjackSprites.png',16,16,8,[255,255,255]); %Loads the Spritesheet
topBorder = [163,163,163,163,163,163,163,163,163,163]; %Creates the top border
bottomBorder = [165,165,165,165,165,165,165,165,165,165]; %Creates the bottom border
leftBorder = [167;166;166;166;166;166;166;169]; %Creates the left border
rightBorder = [168;164;164;164;164;164;164;170]; %Creates the right border
blackjackTable = [topBorder;11:20;21:30;31:40;41:50;51:60;171:180;bottomBorder]; %Combination of table, top border, and bottom border
blackjackTable = horzcat(leftBorder,blackjackTable,rightBorder); %horizonatal concatination of right border, left border, and table
foreground = ones(size(blackjackTable)); %Creates transparent foreground

newBalance = balance; %Used for balance display at the bottom of the screen
currentBet = 0; %Tracks ongoing bet
deck = 61:112; %Creates array for all cards
playerHand = []; %creates blank array for player's hand
playerHand2 = []; %creates blank array for player's 2nd hand in case of split
dealerHand = []; %creates blank array for dealer's hand
turn = 1; %Starts with the player's turn
winner = 0; %Tracks if someone has won the game
loser = 0; %tracks if any hands in a split have busted
playerValue = 0; %tracks the value of player's cards
dealerValue = 0; %tracks the value of dealer's cards
playerValue2 = 0; %tracks the value of player's 2nd hand in case of split
stand = 0; %tracks if first hand was stood in a stand
start = 0; %tacks if bet has been placed and 
doubledown = 0; %tracks if doubledown has been played

%%%%%%%%%%%%%%%%% Audio Files %%%%%%%%%%%%%%%%%
[y4,Fs4] = audioread('cardflip.mp3');
cardflip = audioplayer(y4, Fs4);
[y5,Fs5] = audioread('whoosh.mp3');
carddeal = audioplayer(y5, Fs5); 
[y6,Fs6] = audioread('buttonPress.mp3');
press = audioplayer(y6, Fs6); 

%%%%%%%%%%%%%%%%% Dictionary %%%%%%%%%%%%%%%%%
d = dictionary(); %initializes dictionary
counter = 1; %counter for assigning cards key/value pairs in the dictionary
for i = 1:length(deck) %for loop that iterates through each card in the deck
    if counter >= 1 && counter <= 10 %Checks for number cards
    d = insert(d,deck(i),counter); %Assigns value of counter to current card in dictionary
    counter = counter + 1; %moves to the next value to assign
    elseif counter >= 11 && counter <= 13 %Checks for face cards
        d = insert(d,deck(i),10); %assigns each faces card with a value of 10
        counter = counter + 1; %moves to next value to assign
        if counter == 14 %checks if counter has reached end of a suite
            counter = 1; %resets counter
        end
    end
end

    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Beginning of gameplay loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while 1  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Bet initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if start ~= 1 %checks if betting has already been done
        if currentBet == 0 %Checks to see if "place your bet" screen should be displayed by seeing if there are any current bets
        
            %%%%%%%%%%%%%%%%%%%%%%%% Displays current balance, "place your bet" text and gets first mouseinput %%%%%%%%%%%%%%%%%%%%%%%%

            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            %%% Gets rid of "reset" and "play" buttons if reset is pressed 
            foreground(3,2) = 1; %Transparent
            foreground(3,3) = 1; %Transparent
            foreground(3,10) = 1; %Transparent
            foreground(3,11) = 1; %Transparent
            %%% Turns foreground to "place your bet" message %%%
            foreground(3,4) = 191;
            foreground(3,5) = 192;
            foreground(3,6) = 193;
            foreground(3,7) = 194;
            foreground(3,8) = 195;
            foreground(3,9) = 196;
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            [x,y] = getMouseInput(card_scene); %input for clicking bet buttons
        end
        %update screen if click leave
        if (x == 2 && y == 2)
            close;
            updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
            break;
        end
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Betting Amount Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% 100 Dollar Bet Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if (x == 7 && y == 9) && currentBet <= 1900 && newBalance >= 100 %%%% Checks if 100 button has been pressed. Ensures currentBet will not go over 2000. Ensures newBalance doesnt go under 0.
            %%% Button Press %%%
            foreground(7,9) = 221; %Dark 100
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(7,9) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            
            %%% Adds bet to current bet
            currentBet = currentBet + 100; %Updates the current bet
            newBalance = balance - currentBet; %calculates number to be displayed in total balance  
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            %Updates foreground from "place your bet" to "reset","current bet counter,"play"
            foreground(3,4) = 1; %Transparent
            foreground(3,5) = 1; %Transparent
            foreground(3,6) = (198 + (currentBet/100)); %First section of Bet counter
            foreground(3,7) = 198; %second section of Bet counter
            foreground(3,8) = 1; %Transparent
            foreground(3,9) = 1; %Transparent
            foreground(3,2) = 219; % Reset Button
            foreground(3,3) = 220; % Reset Button
            foreground(3,10) = 145; % Play Button
            foreground(3,11) = 146; % Play Button
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% 500 Dollar Bet Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (x == 7 && y == 10) && currentBet <= 1500 && newBalance >= 500 %%%% Checks if 500 button has been pressed. Ensures currentBet will not go over 2000. Ensures newBalance doesnt go under 0.
            %%% Button Press %%%
            foreground(7,9) = 222; % Dark 500
            foreground(7,10) = 223; % Dark 500
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(7,9) = 1; %Transparent
            foreground(7,10) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            
            %%% Adds bet to current bet
            currentBet = currentBet + 500; %Updates the current bet
            newBalance = balance - currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            %Updates foreground from "place your bet" to "reset","current bet counter,"play"
            foreground(3,4) = 1; %Transparent
            foreground(3,5) = 1; %Transparent
            foreground(3,6) = (198 + (currentBet/100)); %First section of Bet counter
            foreground(3,7) = 198; %second section of Bet counter
            foreground(3,8) = 1; %Transparent
            foreground(3,9) = 1; %Transparent
            foreground(3,2) = 219; % Reset Button
            foreground(3,3) = 220; % Reset Button
            foreground(3,10) = 145; % Play Button
            foreground(3,11) = 146; % Play Button
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%% 1000 Dollar Bet Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (x == 7 && y == 11) && currentBet <= 1000 && newBalance >= 1000 %%%% Checks if 1000 button has been pressed. Ensures currentBet will not go over 2000. Ensures newBalance doesnt go under 0.
            %%% Button Press %%%
            foreground(7,10) = 224; % Dark 1000
            foreground(7,11) = 225; % Dark 1000
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(7,10) = 1; %Transparent
            foreground(7,11) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            currentBet = currentBet + 1000; %Updates the current bet
            
            %%% Adds bet to current bet
            newBalance = balance - currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            %Updates foreground from "place your bet" to "reset","current bet counter,"play"
            foreground(3,4) = 1; %Transparent
            foreground(3,5) = 1; %Transparent
            foreground(3,6) = (198 + (currentBet/100)); %First section of Bet counter
            foreground(3,7) = 198; %second section of Bet counter
            foreground(3,8) = 1; %Transparent
            foreground(3,9) = 1; %Transparent
            foreground(3,2) = 219; % Reset Button
            foreground(3,3) = 220; % Reset Button
            foreground(3,10) = 145; % Play Button
            foreground(3,11) = 146; % Play Button
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  "reset" and "play" Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% "reset" Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif (x == 3 && (y == 2 || y ==3)) && currentBet > 0 %%%% Checks if reset button has been pressed and that the currentBet exists
            %%% Button Press %%%
            foreground(3,2) = 226; %Dark Reset
            foreground(3,3) = 227; %Dark Reset
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(3,2) = 1; %Transparent
            foreground(3,3) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            %%% Reset balance and foreground %%%
            newBalance = balance; %calculates number to be displayed in total balance
            currentBet = 0; %return currentBet back to zero to make sure first if statement can be ran
            foreground = ones(size(blackjackTable)); %%% clears foreground
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%% "play" Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif (x == 3 && (y == 10 || y == 11)) && currentBet > 0 %%%% Checks if play button has been pressed and that the currentBet exists
            %%% Button Press %%%
            foreground(3,10) = 149; %Dark Play
            foreground(3,11) = 150; %Dark Play
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(3,10) = 1; %Transparent
            foreground(3,11) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            %%% Get rid of foreground and start the round %%%
            foreground = ones(size(blackjackTable)); %%% clears foreground
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            start = 1; %%% Indicates that betting is over%%%
        end
    end
    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
    
    %%%%%%%%%%%%%%%%%%%%%% Set foreground of dealer and player total to 0 %%%%%%%%%%%%%%%%%%%%%%
    if isempty(dealerHand) && start == 1 %%%% Checks if betting process is done and game hasn't begun
        foreground(2,11) = 136; % Zero
        foreground(5,11) = 136; % Zero
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Draws the First 4 cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if length(dealerHand) < 2 && winner ~= 1 && start == 1
        
        %%%%%%%%%%%%%%%%%% Deals 4 face down cards with a "Whoosh" sound effect %%%%%%%%%%%%%%%%%%
        
        [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
        [playerValue,d] = playertotal(playerHand,d,playerValue); %%%%% Calculate player value
        foreground(4,6) = 4; % Back of Card
        play(carddeal) % plays audio
        pause(0.5) % Pause for carddeal audio to play
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        pause(0.4)
        foreground(4,7) = 4; % Back of Card
        play(carddeal) % plays audio
        pause(0.5) % Pause for carddeal audio to play
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        pause(0.4)
        foreground(2,6) = 4; % Back of Card
        play(carddeal) % plays audio
        pause(0.6)
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        pause(0.4)
        foreground(2,7) = 4; % Back of Card
        play(carddeal) % plays audio
        pause(0.6)
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Card flipping "Animation" for player, Displays the front of the cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        foreground(4,6) = 113; % Side of the card
        pause(0.7)
        play(cardflip) % plays audio
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        foreground(4,6) = playerHand(1); %Front of playerHand(1)
        pause(0.2)
        foreground(5,11) = 112 + playerValue; %%% Displays Score
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
        [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
        foreground(4,7) = 113; % Side of the card
        pause(0.5) 
        play(cardflip) % plays audio
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        foreground(4,7) = playerHand(2); %Front of playerHand(2)
        pause(0.2)
        foreground(5,11) = 112 + playerValue; %%% Displays Score
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        turn = 0; %Changes turn to dealer turn

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Card flipping "Animation" for dealer, Displays the front of the cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to dealerHand
        [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand
        foreground(2,6) = 113; % Side of the card
        pause(0.5)
        play(cardflip) % plays audio
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        foreground(2,6) = dealerHand(1); %Front of dealerhand(1)
        pause(0.2)
        foreground(2,11) = 112 + dealerValue; %%% Displays Score
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
        foreground(2,7) = 4; % Back of card
        pause(0.7)
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        turn = 1; % Return turn to player
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check for natural Blackjack %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if playerValue == 21  % Checks if player has natural blackjack
            foreground(2,7) = 113; % Side of Card
            play(cardflip) % plays audio
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            foreground(2,7) = dealerHand(2); %Front of dealerHand(2)
            [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand
            foreground(2,11) = 112 + dealerValue; %%% Displays Score
            pause(0.2)
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            if dealerValue ~= 21 % Checks if dealer also has natural blackjack
                foreground(3,2) = 137; % "You" message
                foreground(3,3) = 138; % "You" message
                foreground(4,2) = 139; % "Win" message
                foreground(4,3) = 140; % "Win" message
                newBalance = balance + (currentBet * 1.5); %calculates number to be displayed in total balance
                foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                winner = 1; % indicates that the game has a winner
            else
                foreground(3,2) = 143; % "Push" message
                foreground(3,3) = 144; % "Push" message
            end
        end
    end
    
[x,y] = getMouseInput(card_scene); %input for clicking action buttons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Action Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    if turn == 1 && winner ~= 1 && start == 1 %%%% Checks if it is the player's turn, no one has one yet, and that the betting phase is over
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if (x == 6 && (y == 5 || y == 6)) && (playerValue ~= 21) && (playerValue2 == 0) && (doubledown == 0) && (length(playerHand)) < 8%%%% Checks if hit button has been pressed and that playerValue2 doesnt exist, playerValue isnt 21 and a doubledown hasn't happened
            
            %%% Button Press %%%
            
            foreground(6,5) = 155; %Dark Hit
            foreground(6,6) = 156; %Dark Hit
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,5) = 1; %Transparent
            foreground(6,6) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Player Hand Has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if length(playerHand) == 2 %%% Checks length of player hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,5) = playerHand(1); %Front of playerHand(1)
                foreground(4,6) = playerHand(2); %Front of playerHand(2)
                foreground(4,7) = 1; %Transparent
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                foreground(4,7) = playerHand(3); %Front of playerHand(3)
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                foreground(5,11) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,6) = 134; %Bust
                    foreground(5,7) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    foreground(3,2) = 137; % "You" message
                    foreground(3,3) = 138; % "You" message
                    foreground(4,2) = 141; % "Lose" message
                    foreground(4,3) = 142; % "Lose" message
                    balance = newBalance; %Updates universal balance
                    winner = 1; % indicates that the game has a winner
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Player Hand Has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            elseif length(playerHand) == 3 %%% Checks length of player hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,5) = playerHand(1); %Front of playerHand(1)
                foreground(4,6) = playerHand(2); %Front of playerHand(2)
                foreground(4,7) = playerHand(3); %Front of playerHand(3)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                foreground(4,8) = playerHand(4); %Front of playerHand(4)
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                pause(.1)
                foreground(5,11) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,6) = 134; %Bust
                    foreground(5,7) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    foreground(3,2) = 137; % "You" message
                    foreground(3,3) = 138; % "You" message
                    foreground(4,2) = 141; % "Lose" message
                    foreground(4,3) = 142; % "Lose" message
                    balance = newBalance; %Updates universal balance
                    winner = 1; % indicates that the game has a winner
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Player Hand Has 4 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            elseif length(playerHand) == 4 %%% Checks length of player hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,4) = playerHand(1); %Front of playerHand(1)
                foreground(4,5) = playerHand(2); %Front of playerHand(2)
                foreground(4,6) = playerHand(3); %Front of playerHand(3)
                foreground(4,7) = playerHand(4); %Front of playerHand(4)
                foreground(4,8) = 1; %Transparent
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                foreground(4,8) = playerHand(5); %Front of playerHand(5)
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                pause(0.5) 
                foreground(5,11) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,6) = 134; %Bust
                    foreground(5,7) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    foreground(3,2) = 137; % "You" message
                    foreground(3,3) = 138; % "You" message
                    foreground(4,2) = 141; % "Lose" message
                    foreground(4,3) = 142; % "Lose" message
                    balance = newBalance; %Updates universal balance
                    winner = 1; % indicates that the game has a winner
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Player Hand Has 5 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            elseif length(playerHand) == 5 %%% Checks length of player hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,4) = playerHand(1); %Front of playerHand(1)
                foreground(4,5) = playerHand(2); %Front of playerHand(2)
                foreground(4,6) = playerHand(3); %Front of playerHand(3)
                foreground(4,7) = playerHand(4); %Front of playerHand(4)
                foreground(4,8) = playerHand(5); %Front of playerHand(5)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                foreground(4,9) = playerHand(6); %Front of playerHand(6)
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                pause(0.5)
                foreground(5,11) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,6) = 134; %Bust
                    foreground(5,7) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    foreground(3,2) = 137; % "You" message
                    foreground(3,3) = 138; % "You" message
                    foreground(4,2) = 141; % "Lose" message
                    foreground(4,3) = 142; % "Lose" message
                    balance = newBalance; %Updates universal balance
                    winner = 1; % indicates that the game has a winner
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Player Hand Has 6 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            elseif length(playerHand) == 6 %%% Checks length of player hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,3) = playerHand(1); %Front of playerHand(1)
                foreground(4,4) = playerHand(2); %Front of playerHand(2)
                foreground(4,5) = playerHand(3); %Front of playerHand(3)
                foreground(4,6) = playerHand(4); %Front of playerHand(4)
                foreground(4,7) = playerHand(5); %Front of playerHand(5)
                foreground(4,8) = playerHand(6); %Front of playerHand(6)
                foreground(4,9) = 1; %Transparent
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                foreground(4,9) = playerHand(7); %Front of playerHand(7)
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                pause(0.5)
                foreground(5,11) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,6) = 134; %Bust
                    foreground(5,7) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    foreground(3,2) = 137; % "You" message
                    foreground(3,3) = 138; % "You" message
                    foreground(4,2) = 141; % "Lose" message
                    foreground(4,3) = 142; % "Lose" message
                    balance = newBalance; %Updates universal balance
                    winner = 1; % indicates that the game has a winner
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Player Hand Has 7 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            elseif length(playerHand) == 7 %%% Checks length of player hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,3) = playerHand(1); %Front of playerHand(1)
                foreground(4,4) = playerHand(2); %Front of playerHand(2)
                foreground(4,5) = playerHand(3); %Front of playerHand(3)
                foreground(4,6) = playerHand(4); %Front of playerHand(4)
                foreground(4,7) = playerHand(5); %Front of playerHand(5)
                foreground(4,8) = playerHand(6); %Front of playerHand(6)
                foreground(4,9) = playerHand(7); %Front of playerHand(7)
                foreground(4,10) = playerHand(8); %Front of playerHand(8)
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                pause(0.5)
                foreground(5,11) = 112 + playerValue; %%% Displays Score
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,6) = 134; %Bust
                    foreground(5,7) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    foreground(3,2) = 137; % "You" message
                    foreground(3,3) = 138; % "You" message
                    foreground(4,2) = 141; % "Lose" message
                    foreground(4,3) = 142; % "Lose" message
                    balance = newBalance; %Updates universal balance
                    winner = 1; % indicates that the game has a winner
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            end
        
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Split Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        elseif (x == 6 && (y == 7 || y == 8)) && (d(playerHand(1)) == d(playerHand(2))) && (length(playerHand) == 2) && (isempty(playerHand2)) && ((newBalance - currentBet) > 0) %%%% Checks if Split button was pressed, both cards equal each other, split has already happened, and if player has enough money
            
            %%% Button Press %%%
            
            foreground(6,7) = 157; %Split Dark
            foreground(6,8) = 158; %Split Dark
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,7) = 1; %Transparent
            foreground(6,8) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%% Splits playerHand into playerHand and playerHand2 %%%%%%%%%%%

            if isempty(playerHand2)
                playerHand2 = [playerHand2, playerHand(2)];
                playerHand(2) = [];
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Seperates Cards into 2 hands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
            [playerValue2,d] = player2total(playerHand2,d,playerValue2); %%%% Calculates the current value of playerHand2
            currentBet = currentBet * 2;
            newBalance = balance - currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            foreground(4,5) = playerHand(1); %Front of playerHand(1)
            foreground(4,8) = playerHand2(1); %Front of playerHand2(1)
            foreground(4,6) = 1; %Transparent
            foreground(4,7) = 1; %Transparent
            foreground(5,2) = 161; %Player Total
            foreground(5,3) = 162; %Player Total
            foreground(5,11) = 112 + playerValue2; %%% Displays Score
            foreground(5,4) = 112 + playerValue; %%% Displays Score
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Deals Card Into Each Hand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand);  %%%% Draws a card and adds the value to playerHand
            pause(0.5)
            foreground(4,4) = playerHand(2); %Front of playerHand(2)
            [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
            foreground(5,4) = 112 + playerValue; %%% Displays Score
            play(carddeal) % plays audio
            pause(0.35) % Pause for carddeal audio to play
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            pause(0.5)
            [playerHand2, deck] = dealCard2(turn,deck,playerHand2); %%%% Draws a card and adds the value to playerHand2
            foreground(4,9) = playerHand2(2); %Front of playerHand2(2)
            [playerValue2,d] = player2total(playerHand2,d,playerValue2); %%%% Calculates the current value of playerHand2
            foreground(5,11) = 112 + playerValue2; %%% Displays Score
            play(carddeal) % plays audio
            pause(0.35) % Pause for carddeal audio to play
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hitting For First Deck in a Split %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (x == 6 && (y == 5 || y == 6)) && (playerValue2 > 0) && (loser ~= 1) && (stand == 0) && (playerValue ~= 21) && (length(playerHand2) < 4) %%%% Checks if Hit has been clicked while a split has happend without a loss, stand, or playervalue of 21
            
            %%% Button Press %%%
            
            foreground(6,5) = 155; %Dark Hit
            foreground(6,6) = 156; %Dark Hit
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,5) = 1; %Transparent
            foreground(6,6) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit for the First Hand of a Split When playerHand has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if length(playerHand) == 2 %%%% Checks for length of Player Hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,5) = playerHand(1); %Front of playerHand(1)
                foreground(4,4) = playerHand(2); %Front of playerHand(2)
                foreground(4,3) = playerHand(3); %Front of playerHand(3)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                foreground(5,4) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,4) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,5) = 134; %Bust
                    foreground(5,6) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    loser = loser + 1; %Increases loser count
                    playerValue = 0; %Sets playerValue to 0
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit for the First Hand of a Split When playerHand has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            elseif length(playerHand) == 3 %%%% Checks for length of Player Hand
                [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
                foreground(4,5) = playerHand(1); %Front of playerHand(1)
                foreground(4,4) = playerHand(2); %Front of playerHand(2)
                foreground(4,3) = playerHand(3); %Front of playerHand(3)
                foreground(4,2) = playerHand(4); %Front of playerHand(4)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
                foreground(5,4) = 112 + playerValue; %%% Displays Score
                if playerValue > 21 %%% Checks for Bust
                    foreground(5,4) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,5) = 134; %Bust
                    foreground(5,6) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    loser = loser + 1; %Increases loser count
                    playerValue = 0; %Sets playerValue to 0
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hitting For Second Deck in a Split %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (x == 6 && (y == 5 || y == 6)) && (playerValue2 > 0) && ((loser == 1) || (stand == 1)) && (playerValue2 ~= 21) && (length(playerHand2) < 4)
            
            %%% Button Press %%%
            
            foreground(6,5) = 155; %Dark Hit
            foreground(6,6) = 156; %Dark Hit
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,5) = 1; %Transparent
            foreground(6,6) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit for the Second Hand of a Split When playerHand2 has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if length(playerHand2) == 2 %%%% Checks for length of Player Hand
                [playerHand2, deck] = dealCard2(turn,deck,playerHand2); %%%% Draws a card and adds the value to playerHand2
                foreground(4,8) = playerHand2(1); %Front of playerHand2(1)
                foreground(4,9) = playerHand2(2); %Front of playerHand2(2)
                foreground(4,10) = playerHand2(3); %Front of playerHand2(3)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue2,d] = player2total(playerHand2,d,playerValue2); %%%% Calculates the current value of playerHand2
                foreground(5,11) = 112 + playerValue2; %%% Displays Score
                if playerValue2 > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,7) = 134; %Bust
                    foreground(5,8) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    loser = loser + 1; %Increases loser count
                    playerValue2 = 0; %Sets playerValue to 0
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit for the Second Hand of a Split When playerHand2 has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            elseif length(playerHand2) == 3 %%%% Checks for length of Player Hand
                [playerHand2, deck] = dealCard2(turn,deck,playerHand2); %%%% Draws a card and adds the value to playerHand2
                foreground(4,8) = playerHand2(1); %Front of playerHand2(1)
                foreground(4,9) = playerHand2(2); %Front of playerHand2(2)
                foreground(4,10) = playerHand2(3); %Front of playerHand2(3)
                foreground(4,11) = playerHand2(4); %Front of playerHand2(4)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                play(carddeal) % plays audio
                pause(0.35) % Pause for carddeal audio to play
                [playerValue2,d] = player2total(playerHand2,d,playerValue2); %%%% Calculates the current value of playerHand2
                foreground(5,11) = 112 + playerValue2; %%% Displays Score
                if playerValue2 > 21 %%% Checks for Bust
                    foreground(5,11) = 136; % Zero
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(0.5)
                    foreground(5,7) = 134; %Bust
                    foreground(5,8) = 135; %Bust
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    pause(1)
                    loser = loser + 1; %Increases loser count
                    playerValue2 = 0; %Sets playerValue to 0
                end
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            end

            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Double Down Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (x == 6 && (y == 9 || y == 10)) && (length(playerHand) == 2) && ((newBalance - currentBet) > 0) && isempty(playerHand2)
            
            %%% Button Press %%%
            
            foreground(6,9) = 159; %Dark Double Down
            foreground(6,10) = 160; %Dark Double Down
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,9) = 1; %Transparent
            foreground(6,10) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Set New Balance and Draw Card %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            currentBet = 2 * currentBet;
            newBalance = balance - currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to playerHand
            foreground(4,5) = playerHand(1); %Front of playerHand(1)
            foreground(4,6) = playerHand(2); %Front of playerHand(2)
            foreground(4,7) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            foreground(4,7) = playerHand(3); %Front of playerHand(3)
            play(carddeal) % plays audio
            pause(0.35) % Pause for carddeal audio to play
            [playerValue,d] = playertotal(playerHand,d,playerValue); %%%% Calculates the current value of playerHand
            foreground(5,11) = 112 + playerValue; %%% Displays Score
            if playerValue > 21 %%% Checks for Bust
                foreground(5,11) = 136; % Zero
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                pause(0.5)
                foreground(5,6) = 134; %Bust
                foreground(5,7) = 135; %Bust
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                pause(1)
                foreground(3,2) = 137; % "You" message
                foreground(3,3) = 138; % "You" message
                foreground(4,2) = 141; % "Lose" message
                foreground(4,3) = 142; % "Lose" message
                balance = newBalance; %Updates universal balance
                winner = 1; % indicates that the game has a winner
            end
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            doubledown = 1; %Documents that Double Down has Occured
             
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stand Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

        elseif (x == 6 && (y == 3 || y == 4)) && ((playerValue2 == 0) || ((length(playerHand2) >= 2) && ((stand == 1) || (loser == 1)))) %%%% Checks that stand button has been pressed. Checks if playerValue2 exists or it exits but playerHand 1 has either been lost or stood.
            
            %%% Button Press %%%
            
            foreground(6,3) = 153; %Dark Stand
            foreground(6,4) = 154; %Dark Stand
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,3) = 1; %Transparent
            foreground(6,4) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            turn = 0; % Changes to Dealers turn
            [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check if Dealer Should Stand or Hit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if dealerValue >= 17 && length(dealerHand) == 2
                foreground(2,7) = 113; % Side of the card
                play(cardflip) % plays audio
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                foreground(2,7) = dealerHand(2); %Front of dealerHand(2)
                foreground(2,11) = 112 + dealerValue; %%% Displays Score
                pause(0.2)
                drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            end
        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dealer Hits Until dealerValue >= 17 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            while dealerValue < 17
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Dealer Hand Has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                if length(dealerHand) == 2 %%%% Checks for length of Dealer Hand
                    
                    %%% Card Flip %%%

                    [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to dealerHand
                    foreground(2,7) = 113; % Side of the card
                    play(cardflip) % plays audio
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    foreground(2,7) = dealerHand(2); %Front of dealerHand(2)
                    foreground(2,11) = 112 + dealerValue; %%% Displays Score
                    pause(0.2)
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    
                    %%%%%%%%%%%%%% Deal Card %%%%%%%%%%%%%%
                    
                    foreground(2,5) = dealerHand(1); %Front of dealerhand(1)
                    foreground(2,6) = dealerHand(2); %Front of dealerHand(2)
                    foreground(2,7) = 1; %Transparent 
                    pause(0.5)
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    foreground(2,7) = dealerHand(3); %Front of dealerHand(3)
                    play(carddeal) % plays audio
                    pause(0.35) % Pause for carddeal audio to play
                    [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand
                    foreground(2,11) = 112 + dealerValue; %%% Displays Score
                    if dealerValue > 21 % Check for Bust
                        foreground(2,11) = 136; % Zero
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(0.5)
                        foreground(3,6) = 134; %Bust
                        foreground(3,7) = 135; %Bust
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(1)
                        foreground(3,2) = 137; % "You" message
                        foreground(3,3) = 138; % "You" message
                        foreground(4,2) = 139; % "Win" message
                        foreground(4,3) = 140; % "Win" message
                        newBalance = balance + currentBet; %calculates number to be displayed in total balance
                        foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        winner = 1; % indicates that the game has a winner
                        break
                    end
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Dealer Hand Has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                elseif length(dealerHand) == 3 %%%% Checks for length of Dealer Hand
                    [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to dealerHand
                    pause(0.5)
                    foreground(2,5) = dealerHand(1); %Front of dealerhand(1)
                    foreground(2,6) = dealerHand(2); %Front of dealerHand(2)
                    foreground(2,7) = dealerHand(3); %Front of dealerHand(3)
                    foreground(2,8) = dealerHand(4); %Front of dealerHand(4)
                    play(carddeal) % plays audio
                    pause(0.35) % Pause for carddeal audio to play
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    play(carddeal) % plays audio
                    pause(0.35) % Pause for carddeal audio to play
                    [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand
                    foreground(2,11) = 112 + dealerValue; %%% Displays Score
                    if dealerValue > 21 % Check for Bust
                        foreground(2,11) = 136; % Zero
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(0.5)
                        foreground(3,6) = 134; %Bust
                        foreground(3,7) = 135; %Bust
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(1)
                        foreground(3,2) = 137; % "You" message
                        foreground(3,3) = 138; % "You" message
                        foreground(4,2) = 139; % "Win" message
                        foreground(4,3) = 140; % "Win" message
                        newBalance = balance + currentBet; %calculates number to be displayed in total balance
                        foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        winner = 1; % indicates that the game has a winner
                        break
                    end
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Dealer Hand Has 4 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                elseif length(dealerHand) == 4 %%%% Checks for length of Dealer Hand
                    [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to dealerHand
                    foreground(2,4) = dealerHand(1); %Front of dealerhand(1)
                    foreground(2,5) = dealerHand(2); %Front of dealerHand(2)
                    foreground(2,6) = dealerHand(3); %Front of dealerHand(3)
                    foreground(2,7) = dealerHand(4); %Front of dealerHand(4)
                    foreground(2,8) = dealerHand(5); %Front of dealerHand(5)
                    pause(0.5)
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    play(carddeal) % plays audio
                    pause(0.35) % Pause for carddeal audio to play
                    [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand
                    foreground(2,11) = 112 + dealerValue; %%% Displays Score
                    if dealerValue > 21 % Check for Bust
                        foreground(2,11) = 136; % Zero
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(0.5)
                        foreground(3,6) = 134; %Bust
                        foreground(3,7) = 135; %Bust
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(1)
                        foreground(3,2) = 137; % "You" message
                        foreground(3,3) = 138; % "You" message
                        foreground(4,2) = 139; % "Win" message
                        foreground(4,3) = 140; % "Win" message
                        newBalance = balance + currentBet; %calculates number to be displayed in total balance
                        foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        winner = 1; % indicates that the game has a winner
                        break
                    end
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hit When Dealer Hand Has 5 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                elseif length(dealerHand) == 5 %%%% Checks for length of Dealer Hand
                    [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand); %%%% Draws a card and adds the value to dealerHand
                    foreground(2,3) = dealerHand(1); %Front of dealerhand(1)
                    foreground(2,4) = dealerHand(2); %Front of dealerHand(2)
                    foreground(2,5) = dealerHand(3); %Front of dealerHand(3)
                    foreground(2,6) = dealerHand(4); %Front of dealerHand(4)
                    foreground(2,7) = dealerHand(5); %Front of dealerHand(5)
                    foreground(2,8) = dealerHand(6); %Front of dealerHand(6)
                    pause(0.5)
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                    play(carddeal) % plays audio
                    pause(0.35) % Pause for carddeal audio to play
                    [dealerValue,d] = dealertotal(dealerHand,d,dealerValue); %%%% Calculates the current value of dealerHand
                    foreground(2,11) = 112 + dealerValue; %%% Displays Score
                    if dealerValue > 21 % Check for Bust
                        foreground(2,11) = 136; % Zero
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(0.5)
                        foreground(3,6) = 134; %Bust
                        foreground(3,7) = 135; %Bust
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        pause(1)
                        foreground(3,2) = 137; % "You" message
                        foreground(3,3) = 138; % "You" message
                        foreground(4,2) = 139; % "Win" message
                        foreground(4,3) = 140; % "Win" message
                        newBalance = balance + currentBet; %calculates number to be displayed in total balance
                        foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
                        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
                        winner = 1; % indicates that the game has a winner
                        break
                    end
                    drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

                elseif length(dealerHand) == 6
                    break
                end

            end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Split First Hand Stand Button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

        elseif (x == 6 && (y == 3 || y == 4)) && playerValue2 > 0
            foreground(6,3) = 153; %Dark Stand
            foreground(6,4) = 154; %Dark Stand
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(6,3) = 1; %Transparent
            foreground(6,4) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            stand = 1; % Indicates that the first hand has stood in a split
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Winner Check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (dealerValue >= 17) && (winner ~= 1) && (loser ~= 2) && isempty(playerHand2) % Check for non-split rounds
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Dealer Win %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if (dealerValue > playerValue)
            foreground(3,2) = 137; % "You" message
            foreground(3,3) = 138; % "You" message
            foreground(4,2) = 141; % "Lose" message
            foreground(4,3) = 142; % "Lose" message
            newBalance = balance - currentBet; %calculates number to be displayed in total balance 
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            winner = 1;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Player Win %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (dealerValue < playerValue) 
            foreground(3,2) = 137; % "You" message
            foreground(3,3) = 138; % "You" message
            foreground(4,2) = 139; % "Win" message
            foreground(4,3) = 140; % "Win" message
            winner = 1; % indicates that the game has a winner
            newBalance = balance + currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Tie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        else
            foreground(3,2) = 143; % "Push" message
            foreground(3,3) = 144; % "Push" message
            winner = 1; % indicates that the game has a winner
            newBalance = balance; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        end
        
    elseif (dealerValue >= 17) && (winner ~= 1) && (~isempty(playerHand2)) && (loser ~= 2) % Check for Split Rounds

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Player Win on Both Hands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if (dealerValue < playerValue) && (dealerValue < playerValue2)
            foreground(3,2) = 137; % "You" message
            foreground(3,3) = 138; % "You" message
            foreground(4,2) = 139; % "Win" message
            foreground(4,3) = 140; % "Win" message
            winner = 1; % indicates that the game has a winner
            newBalance = balance + currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Dealer Win on one Hand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif ((dealerValue > playerValue) && (dealerValue < playerValue2)) ||  ((dealerValue < playerValue) && (dealerValue > playerValue2))
            foreground(3,2) = 143; % "Push" message
            foreground(3,3) = 144; % "Push" messa
            winner = 1; % indicates that the game has a winner
            newBalance = balance; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Dealer Win on Both Hands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif (dealerValue > playerValue) && (dealerValue > playerValue2)
            foreground(3,2) = 137; % "You" message
            foreground(3,3) = 138; % "You" message
            foreground(4,2) = 141; % "Lose" message
            foreground(4,3) = 142; % "Lose" message
            winner = 1; % indicates that the game has a winner
            newBalance = balance - currentBet; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Tie and Win %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif ((dealerValue < playerValue) && (dealerValue == playerValue2)) || ((dealerValue == playerValue) && (dealerValue < playerValue2))
            foreground(3,2) = 137; % "You" message
            foreground(3,3) = 138; % "You" message
            foreground(4,2) = 139; % "Win" message
            foreground(4,3) = 140; % "Win" message
            winner = 1; % indicates that the game has a winner
            newBalance = balance + (currentBet/2); %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Tie and Loss %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif ((dealerValue > playerValue) && (dealerValue == playerValue2)) || ((dealerValue == playerValue) && (dealerValue > playerValue2))
            foreground(3,2) = 137; % "You" message
            foreground(3,3) = 138; % "You" message
            foreground(4,2) = 139; % "Lose" message
            foreground(4,3) = 140; % "Lose" message
            winner = 1; % indicates that the game has a winner
            newBalance = balance - (currentBet/2); %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result for Tie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        else 
            foreground(3,2) = 143; % "Push" message
            foreground(3,3) = 144; % "Push" messa
            winner = 1; % indicates that the game has a winner
            newBalance = balance; %calculates number to be displayed in total balance
            foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Both Hands Bust %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif loser == 2 % Check if Both Split Hands Busted
         foreground(3,2) = 137; % "You" message
         foreground(3,3) = 138; % "You" message
         foreground(4,2) = 141; % "Lose" message
         foreground(4,3) = 142; % "Lose" message
         newBalance = balance - currentBet; %calculates number to be displayed in total balance
         foreground = balanceButton(foreground,newBalance); %%%loads balance in the foreground
         winner = 1; % indicates that the game has a winner
         drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End Screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if winner == 1
        foreground(3,5) = 145; % Play Button
        foreground(3,6) = 146; % Play Button
        foreground(3,7) = 147; % Quit Button
        foreground(3,8) = 148; % Quit Button
        drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
        if x == 3 && (y == 5 || y == 6)
            foreground(3,5) = 149; % Dark Play
            foreground(3,6) = 150; % Dark Play
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            play(press) % plays audio
            pause(0.15) % pause for press audio to play
            foreground(3,5) = 1; %Transparent
            foreground(3,6) = 1; %Transparent
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            drawScene(card_scene,blackjackTable,foreground); %%% Updates foreground
            foreground = ones(size(blackjackTable)); %%% clears foreground
            pause(0.1)
            currentBet = 0; %Reset Value
            deck = 61:112; %Reset Value
            playerHand = []; %Reset Value
            playerHand2 = []; %Reset Value
            dealerHand = []; %Reset Value
            turn = 1; %Reset Value
            winner = 0; %Reset Value
            loser = 0; %Reset Value
            playerValue = 0; %Reset Value
            dealerValue = 0; %Reset Value
            playerValue2 = 0; %Reset Value
            stand = 0; %Reset Value
            start = 0; %Reset Value
            balance = newBalance; %Updates universal balance
            doubledown = 0; %Reset Value
        elseif x == 3 && (y == 7 || y == 8 )
            close;
            balance = newBalance;
            updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
            break;
        end
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Card Draw Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Card Draw for playerHand and dealerHand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [playerHand, dealerHand, deck] = dealCard(turn,deck,playerHand,dealerHand)
    card = deck(end,randperm(size(deck,2), 1)); %% Creates placeholder "card"
    if turn == 1 %% Checks if it is the player's turn
        playerHand = [playerHand,card]; %% Appends the card to playerHand
    else %% Checks if it is the dealer's turn
        dealerHand = [dealerHand,card]; %% Appends the card to dealerHand
    end
    deck(deck == card) = []; %Removes "card" from "deck" for no repeats
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Card Draw for playerHand2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [playerHand2, deck] = dealCard2(turn,deck,playerHand2)
    card = deck(end,randperm(size(deck,2), 1)); %% Creates placeholder "card"
    if turn == 1 %% Checks if it is the player's turn
        playerHand2 = [playerHand2,card]; %% Appends the card to playerHand2
    end
    deck(deck == card) = []; %Removes "card" from "deck" for no repeats
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value Calculation Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value Calculation for playerHand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [playerValue,d] = playertotal(playerHand,d,playerValue)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 1 Card %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if length(playerHand) == 1 % Check the length of playerHand
        if d(playerHand(1)) == 1 % Check if current card is an ace
            d(playerHand(1)) = 11; %Set Ace to 11
            playerValue = playerValue + d(playerHand(1)); % Add Current Card to playerValue
        else
            playerValue = d(playerHand(1)); % Set playerValue to Current Card
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand) == 2 % Check the length of playerHand
        if d(playerHand(2)) == 1 % Check if current card is an ace
            if playerValue <= 10 % Check if Ace should be 11 or 1
                d(playerHand(2)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(2)); % Add Current Card to playerValue
            else
                d(playerHand(2)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(2)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(2)); % Add Current Card to playerValue
        end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand) == 3 % Check the length of playerHand
        if d(playerHand(3)) == 1 % Check if current card is an ace
            if playerValue <= 10  % Check if Ace should be 11 or 1
                d(playerHand(3)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(3)); % Add Current Card to playerValue
            else
                d(playerHand(3)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(3)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(3)); % Add Current Card to playerValue
            
            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand to see if ace can be changed to not bust %%%%%%%%%%%%%%%
            
            if (playerValue > 21) && (d(playerHand(1)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(1)) = 1;
            elseif (playerValue > 21) && (d(playerHand(2)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(2)) = 1;
            end
        end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 4 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand) == 4 % Check the length of playerHand
        if d(playerHand(4)) == 1 % Check if current card is an ace
            if playerValue <= 10  % Check if Ace should be 11 or 1
                d(playerHand(4)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(4)); % Add Current Card to playerValue
            else
                d(playerHand(4)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(4)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(4)); % Add Current Card to playerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue > 21) && (d(playerHand(1)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(1)) = 1;
            elseif (playerValue > 21) && (d(playerHand(2)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(2)) = 1;
            elseif (playerValue > 21) && (d(playerHand(3)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(3)) = 1;
            end
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 5 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand) == 5 % Check the length of playerHand
        if d(playerHand(5)) == 1 % Check if current card is an ace
            if playerValue <= 10  % Check if Ace should be 11 or 1
                d(playerHand(5)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(5)); % Add Current Card to playerValue
            else
                d(playerHand(5)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(5)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(5)); % Add Current Card to playerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue > 21) && (d(playerHand(1)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(1)) = 1;
            elseif (playerValue > 21) && (d(playerHand(2)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(2)) = 1;
            elseif (playerValue > 21) && (d(playerHand(3)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(3)) = 1;
            elseif (playerValue > 21) && (d(playerHand(4)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(4)) = 1;
            end
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 6 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    elseif length(playerHand) == 6 % Check the length of playerHand
        if d(playerHand(6)) == 1 % Check if current card is an ace
            if playerValue <= 10  % Check if Ace should be 11 or 1
                d(playerHand(6)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(6)); % Add Current Card to playerValue
            else
                d(playerHand(6)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(6)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(6)); % Add Current Card to playerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue > 21) && (d(playerHand(1)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(1)) = 1;
            elseif (playerValue > 21) && (d(playerHand(2)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(2)) = 1;
            elseif (playerValue > 21) && (d(playerHand(3)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(3)) = 1;
            elseif (playerValue > 21) && (d(playerHand(4)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(4)) = 1;
            elseif (playerValue > 21) && (d(playerHand(5)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(5)) = 1;
            end
        end
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 7 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand) == 7  % Check the length of playerHand  
        if d(playerHand(7)) == 1 % Check if current card is an ace
            if playerValue <= 10  % Check if Ace should be 11 or 1
                d(playerHand(7)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(7)); % Add Current Card to playerValue
            else
                d(playerHand(7)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(7)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(7)); % Add Current Card to playerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue > 21) && (d(playerHand(1)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(1)) = 1;
            elseif (playerValue > 21) && (d(playerHand(2)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(2)) = 1;
            elseif (playerValue > 21) && (d(playerHand(3)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(3)) = 1;
            elseif (playerValue > 21) && (d(playerHand(4)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(4)) = 1;
            elseif (playerValue > 21) && (d(playerHand(5)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(5)) = 1;
            elseif (playerValue > 21) && (d(playerHand(6)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(6)) = 1;
            end
        end
           
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand Has 8 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand) == 8 % Check the length of playerHand
        if d(playerHand(8)) == 1 % Check if current card is an ace
            if playerValue <= 10  % Check if Ace should be 11 or 1
                d(playerHand(8)) = 11; %Set Ace to 11
                playerValue = playerValue + d(playerHand(8)); % Add Current Card to playerValue
            else
                d(playerHand(8)) = 1; %Set Ace to 1
                playerValue = playerValue + d(playerHand(8)); % Add Current Card to playerValue
            end
        else
            playerValue = playerValue + d(playerHand(8)); % Add Current Card to playerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue > 21) && (d(playerHand(1)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(1)) = 1;
            elseif (playerValue > 21) && (d(playerHand(2)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(2)) = 1;
            elseif (playerValue > 21) && (d(playerHand(3)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(3)) = 1;
            elseif (playerValue > 21) && (d(playerHand(4)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(4)) = 1;
            elseif (playerValue > 21) && (d(playerHand(5)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(5)) = 1;
            elseif (playerValue > 21) && (d(playerHand(6)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(6)) = 1;
            elseif (playerValue > 21) && (d(playerHand(7)) == 11)
                playerValue = playerValue - 10;
                d(playerHand(7)) = 1;
            end
        end   
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value Calculation for playerHand2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [playerValue2,d] = player2total(playerHand2,d,playerValue2)
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand2 Has 1 Card %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if length(playerHand2) == 1 % Check the length of playerHand2
        if d(playerHand2(1)) == 1 % Check if current card is an ace
            d(playerHand(1)) = 11; %Set Ace to 11
            playerValue2 = playerValue2 + d(playerHand2(1)); % Add Current Card to playerValue2
        else
            playerValue2 = d(playerHand2(1)); % Set playerValue2 to Current Card
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand2 Has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand2) == 2 % Check the length of playerHand2
        if d(playerHand2(2)) == 1 % Check if current card is an ace
            if playerValue2 <= 10 % Check if Ace should be 11 or 1
                d(playerHand2(2)) = 11; %Set Ace to 11
                playerValue2 = playerValue2 + d(playerHand2(2)); % Add Current Card to playerValue2
            else
                d(playerHand2(2)) = 1; %Set Ace to 1
                playerValue2 = playerValue2 + d(playerHand2(2)); % Add Current Card to playerValue2
            end
        else
            playerValue2 = playerValue2 + d(playerHand2(2)); % Add Current Card to playerValue2
        end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand2 Has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand2) == 3 % Check the length of playerHand2
        if d(playerHand2(3)) == 1 % Check if current card is an ace
            if playerValue2 <= 10 % Check if Ace should be 11 or 1
                d(playerHand2(3)) = 11; %Set Ace to 11
                playerValue2 = playerValue2 + d(playerHand2(3)); % Add Current Card to playerValue2
            else
                d(playerHand2(3)) = 1; %Set Ace to 1
                playerValue2 = playerValue2 + d(playerHand2(3)); % Add Current Card to playerValue2
            end
        else
            playerValue2 = playerValue2 + d(playerHand2(3)); % Add Current Card to playerValue2\

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand2 to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue2 > 21) && (d(playerHand2(1)) == 11)
                playerValue2 = playerValue2 - 10;
                d(playerHand2(1)) = 1;
            elseif (playerValue2 > 21) && (d(playerHand2(2)) == 11)
                playerValue2 = playerValue2 - 10;
                d(playerHand2(2)) = 1;
            end
        end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When playerHand2 Has 4 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(playerHand2) == 4 % Check the length of playerHand2
        if d(playerHand2(4)) == 1 % Check if current card is an ace
            if playerValue2 <= 10 % Check if Ace should be 11 or 1
                d(playerHand2(4)) = 11; %Set Ace to 11
                playerValue2 = playerValue2 + d(playerHand2(4)); % Add Current Card to playerValue2
            else
                d(playerHand2(4)) = 1; %Set Ace to 1
                playerValue2 = playerValue2 + d(playerHand2(4)); % Add Current Card to playerValue2
            end
        else
            playerValue2 = playerValue2 + d(playerHand2(4)); % Add Current Card to playerValue2

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand2 to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (playerValue2 > 21) && (d(playerHand2(1)) == 11)
                playerValue2 = playerValue2 - 10;
                d(playerHand2(1)) = 1;
            elseif (playerValue2 > 21) && (d(playerHand2(2)) == 11)
                playerValue2 = playerValue2 - 10;
                d(playerHand2(2)) = 1;
            elseif (playerValue2 > 21) && (d(playerHand2(3)) == 11)
                playerValue2 = playerValue2 - 10;
                d(playerHand2(3)) = 1;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value Calculation for dealerHand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [dealerValue,d] = dealertotal(dealerHand,d,dealerValue)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When dealerHand Has 1 Card %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if length(dealerHand) == 1 % Check the length of dealerHand
        if d(dealerHand(1)) == 1 % Check if current card is an ace
            d(dealerHand(1)) = 11; %Set Ace to 11
            dealerValue = dealerValue + d(dealerHand(1)); % Add Current Card to dealerValue
        else
            dealerValue = d(dealerHand(1)); % set dealerValue to Current Card
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When dealerHand Has 2 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(dealerHand) == 2 % Check the length of dealerHand
        if d(dealerHand(2)) == 1 % Check if current card is an ace
            if dealerValue <= 10 % Check if Ace should be 11 or 1
                d(dealerHand(2)) = 11; %Set Ace to 11
                dealerValue = dealerValue + d(dealerHand(2)); % Add Current Card to dealerValue
            else
                d(dealerHand(2)) = 1; %Set Ace to 1
                dealerValue = dealerValue + d(dealerHand(2)); % Add Current Card to dealerValue
            end
        else
            dealerValue = dealerValue + d(dealerHand(2)); % Add Current Card to dealerValue
        end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When dealerHand Has 3 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(dealerHand) == 3 % Check the length of dealerHand
        if d(dealerHand(3)) == 1 % Check if current card is an ace
            if dealerValue <= 10 % Check if Ace should be 11 or 1
                d(dealerHand(3)) = 11; %Set Ace to 11
                dealerValue = dealerValue + d(dealerHand(3)); % Add Current Card to dealerValue
            else
                d(dealerHand(3)) = 1; %Set Ace to 1
                dealerValue = dealerValue + d(dealerHand(3)); % Add Current Card to dealerValue
            end
        else
            dealerValue = dealerValue + d(dealerHand(3)); % Add Current Card to dealerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand2 to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (dealerValue > 21) && (d(dealerHand(1)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(1)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(2)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(2)) = 1;
            end
        end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When dealerHand Has 4 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(dealerHand) == 4 % Check the length of dealerHand
        if d(dealerHand(4)) == 1 % Check if current card is an ace
            if dealerValue <= 10 % Check if Ace should be 11 or 1
                d(dealerHand(4)) = 11; %Set Ace to 11
                dealerValue = dealerValue + d(dealerHand(4)); % Add Current Card to dealerValue
            else
                d(dealerHand(4)) = 1; %Set Ace to 1
                dealerValue = dealerValue + d(dealerHand(4)); % Add Current Card to dealerValue
            end
        else
            dealerValue = dealerValue + d(dealerHand(4)); % Add Current Card to dealerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand2 to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (dealerValue > 21) && (d(dealerHand(1)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(1)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(2)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(2)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(3)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(3)) = 1;
            end
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When dealerHand Has 5 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    elseif length(dealerHand) == 5 % Check the length of dealerHand
        if d(dealerHand(5)) == 1 % Check if current card is an ace
            if dealerValue <= 10 % Check if Ace should be 11 or 1
                d(dealerHand(5)) = 11; %Set Ace to 11
                dealerValue = dealerValue + d(dealerHand(5)); % Add Current Card to dealerValue
            else
                d(dealerHand(5)) = 1; %Set Ace to 1
                dealerValue = dealerValue + d(dealerHand(5)); % Add Current Card to dealerValue
            end
        else
            dealerValue = dealerValue + d(dealerHand(5)); % Add Current Card to dealerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand2 to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (dealerValue > 21) && (d(dealerHand(1)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(1)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(2)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(2)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(3)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(3)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(4)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(4)) = 1;
            end
        end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Value When dealerHand Has 6 Cards %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    elseif length(dealerHand) == 6 % Check the length of dealerHand
        if d(dealerHand(6)) == 1 % Check if current card is an ace
            if dealerValue <= 10 % Check if Ace should be 11 or 1
                d(dealerHand(6)) = 11; %Set Ace to 11
                dealerValue = dealerValue + d(dealerHand(6)); % Add Current Card to dealerValue
            else
                d(dealerHand(6)) = 1; %Set Ace to 1
                dealerValue = dealerValue + d(dealerHand(6)); % Add Current Card to dealerValue
            end
        else
            dealerValue = dealerValue + d(dealerHand(6)); % Add Current Card to dealerValue

            %%%%%%%%%%%%%%% In case of bust, iterate over playerHand2 to see if ace can be changed to not bust %%%%%%%%%%%%%%%

            if (dealerValue > 21) && (d(dealerHand(1)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(1)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(2)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(2)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(3)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(3)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(4)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(4)) = 1;
            elseif (dealerValue > 21) && (d(dealerHand(5)) == 11)
                dealerValue = dealerValue - 10;
                d(dealerHand(5)) = 1;
            end
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Balance Calculation Function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function foreground = balanceButton(foreground,newBalance)
    formattedBalance = sprintf('%05d', newBalance); 
    for i = 1:5 % Iterate through each digit
        %Use math to relate the foreground position to the balance number
        foreground(7,i+2) = 181 + str2double(formattedBalance(i));
    end
end

end


