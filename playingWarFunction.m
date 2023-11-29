function balance = playingWarFunction(balance, userBet,numRounds)
    
    %adding this to cheat my way back to my screen instead of redoing the
    %figure logic.

    casinoEnter = simpleGameEngine('tryingnewsheet.png',50,50,2);

    %Entering casino splash
    entercasinoSplash = zeros(13,13);
    %Loop through pixel indices 
    counterSplash = 1;
    for i = 1:13
        for j = 1:13
            entercasinoSplash(i,j) = counterSplash;
            counterSplash = counterSplash + 1;
        end  
    end
        
    %Set the foreground (246 is the index of an arbitrary transparent sprite)
    entercasinoForeground = 246 * ones(size(entercasinoSplash));




    retroCardFullArray = [1:10; 11:20; 21:30; 31:40; 41:50; 51:60; 61:70; 71:80; 81:90; 91:100];
    gameLayout = simpleGameEngine('edited_retro_cards.png',16,16,8,[103,58,183]);
    
    %Variables keeping track of who has won and who has lost
    oppWin = 0;
    userWin = 0;
    playedRounds = 0;
    
    
    
    %Specific Cards
    blankCard = retroCardFullArray(1,2);
    noCard = retroCardFullArray(1,1);
    redCheckBack = retroCardFullArray(1,4);
    blueCheckBack = retroCardFullArray(1,6);
    
    %Suits do not matter. Commenting for visibility
    %Suits 
    %heartSuit = [retroCardFullArray(3,:), retroCardFullArray(4,1:3)];
    %diamondSuit = [retroCardFullArray(4, 4:end), retroCardFullArray(5,1:6)];
    %clubSuit = [retroCardFullArray(5,7:end), retroCardFullArray(6, 1:9)];
    %spadeSuit = [retroCardFullArray(6,end), retroCardFullArray(7, 1:end), retroCardFullArray(8,1:2)];
    
    %complete card deck
    %cardDeck = [heartSuit; diamondSuit; clubSuit; spadeSuit];

    cardDeck = 21:74;
    
    %Words
    playerWord = retroCardFullArray(9,1:6);
    opponentWord = retroCardFullArray(10,1:8);
    
    %Crown
    crown = retroCardFullArray(9,9);
    
    %baseLayer - includes the word opponent, opponents cards (facedown, oponents
    %active card spot, player's active card spot, player's cards (facedown), and 
    %the word player
    
        baseLayer = ones(12,11) * noCard;
        baseLayer(6:7,6) = blankCard;
        baseLayer(1,3:10) = opponentWord;
        baseLayer(12,4:9) = playerWord;
        baseLayer(3,7:9) = blueCheckBack;
        baseLayer(10,3:5) = redCheckBack;
    
    %topLayer - changes the card that is displayed by both the user and the
    %opponent in the middle.
    topLayer = ones(12,11) * noCard;
    
    %Creating the initial scene
    drawScene(gameLayout, baseLayer, topLayer)
    
    %creating both the user and opponent decks
    [userDeck, opponentDeck] = assignCards();
    
    %variable for first while loop
    multipleRounds = true;
    
    %variables in second while loop
    notEmpty = true;
    uI = 1;
    oI = 1;
    
    while(multipleRounds)
        while(notEmpty)
        
             %creating variables that hold the size of the two arrays
             userDeckSize = length(userDeck);
             opponentDeckSize = length(opponentDeck);
        
              baseLayer(3,7:9) = blueCheckBack;
              baseLayer(10,3:5) = redCheckBack;  
        
             % find which has the greater number of cards and give the crown to
             % that player
             if(userDeckSize > opponentDeckSize)
                  topLayer(12,3) = crown;
                  topLayer(1,2) = noCard;
             elseif(userDeckSize < opponentDeckSize)
                  topLayer(1,2) = crown;
                  topLayer(12,3) = noCard;
             elseif(userDeckSize == opponentDeckSize)
                  topLayer(12,3) = crown;
                  topLayer(1,2) = crown;
             end
        
             drawScene(gameLayout, baseLayer, topLayer)
        
             %Check to see if the index value for the user or the opponent exceeds
             %the number of elements in the list.  If it does set the index back to
             %one.     
        
             if(userDeckSize < uI)
                 uI = 1;
             end
        
             if(opponentDeckSize < oI)
                 oI = 1;
             end
        
                %Set opponentCard to the value at index oI and set userCard to the
                %value at index uI.
                opponentCard = opponentDeck(oI);
                userCard = userDeck(uI);
                
                % space bar input
                press = getKeyboardInput(gameLayout);
        
                    topLayer(6,6) = opponentCard;
                    topLayer(7,6) = userCard;
             
             %Assigning a variable to the value is on the card face.
        
            userCardID = mod(userCard-20,13);
            opponentCardID = mod(opponentCard-20,13);
        
                %Fixing weird glitched card (This is not a fix)
                %if(opponentCardID == 6)
                    %opponentCard = cardDeck(1,6);
               % end
            
            %setting values for ace and king so they are the highest value cards
            if(userCardID == 1)
                userCardID = 14;
            elseif(userCardID == 0)
                %There's the error can you believe I found it crazy...
                %userCard = 13;
                userCardID = 13;
            end
        
            if(opponentCardID == 1)
                opponentCardID = 14;
            elseif(opponentCardID == 0)
                opponentCardID = 13;
            end
        
        
            %appending the card to the winners deck and removing it from the losers
            %deck
            if(userCardID > opponentCardID)
                userDeck(end+1) = opponentCard;
                opponentDeck(oI) = [];
                drawScene(gameLayout, baseLayer, topLayer)
            elseif(userCardID < opponentCardID)
                opponentDeck(end+1) = userCard;
                userDeck(uI) = [];
                drawScene(gameLayout, baseLayer, topLayer)
            else
                pause(0.3);
                %have three cards horizontally behind each payers card, flip the
                %fourth card... have each card be presented with the space bar,
                %have the card presented be blank until the fourth hit... maybe
                %remove the cards present and put the word war on the sides twice
                tieLayer = ones(12,11) * noCard;
                baseLayer(3,7:9) = noCard;
                baseLayer(10,3:5) = noCard;
        
                tieLayer(6,6) = opponentCard;
                tieLayer(7,6) = userCard;
        
                drawScene(gameLayout, baseLayer, tieLayer)
                pause(0.3)
        
                press = getKeyboardInput(gameLayout);
                tieLayer(6,6) = noCard;
                tieLayer(7,6) = noCard;
        
                drawScene(gameLayout, baseLayer, tieLayer)
                pause(0.3)
        
                for(i=1:3)
                    press = getKeyboardInput(gameLayout);
                    tieLayer(8,4+i) = redCheckBack;
                    tieLayer(5,4+i) = blueCheckBack;
                    drawScene(gameLayout, baseLayer, tieLayer)
                end
        
                press = getKeyboardInput(gameLayout);
                
                uI = uI + 3;
                oI = oI + 3;
        
                 if(userDeckSize < uI)
                     uI = 4;
                 end
            
                 if(opponentDeckSize < oI)
                     oI = 4;
                 end
        
                %Resetting card IDs
                opponentCard = opponentDeck(oI);
                userCard = userDeck(uI);
        
                userCardID = mod(userCard-20,13);
                opponentCardID = mod(opponentCard-20,13);
            
            
                %setting values for ace and king so they are the highest value cards
                if(userCardID == 1)
                    userCardID = 14;
                elseif(userCardID == 0)
                    userCardID = 13;
                end
            
                if(opponentCardID == 1)
                    opponentCardID = 14;
                elseif(opponentCardID == 0)
                    opponentCardID = 13;
                end
        
                    if(userCardID > opponentCardID)
                            userDeck=[userDeck, opponentCard, opponentDeck(oI-3), opponentDeck(oI-2), opponentDeck(oI-1)];
                            opponentDeck(oI:-1:oI-3) = [];
        
                     elseif(userCardID < opponentCardID)
                            opponentDeck = [opponentDeck, userCard, userDeck(uI-3), userDeck(uI-2), userDeck(uI-1)];
                            userDeck(uI:-1:uI-3) = [];
                    
                     end
        
                tieLayer(6,6) = opponentCard;
                tieLayer(7,6) = userCard;
                topLayer(6:7,6) = blankCard;
                drawScene(gameLayout, baseLayer, tieLayer)
                pause(0.3)
        
            end
        
        
             %Compares the deck sizes.  If one is equal to fifteen then the game is
             %over and a variable called userLoses keeps track of who won.
             userDeckSize = length(userDeck);
             opponentDeckSize = length(opponentDeck);
             
             if(userDeckSize>15 && opponentDeckSize>15)
                 notEmpty = true;
        
             elseif(userDeckSize<=15 && opponentDeckSize>15)
                 userLoses = true;
                 notEmpty = false;
        
             elseif(userDeckSize>15 && opponentDeckSize<=15)
                 userLoses = false;
                 notEmpty = false;
        
             end
        
             uI = uI + 1;
             oI = oI + 1;
            
        end
    
        if(userLoses)
            oppWin = oppWin + 1;
        else
            userWin = userWin + 1;
        end
    
        if(numRounds == 3) && (userWin == 2)
            balance = balance + userBet;
            multipleRounds = false;
    
            %win screen
            winnerLayer = ones(12,12) * noCard;
            winnerLayer(6:8,3:10) = crown;
            winnerLayer(6,[5,8]) = noCard;
            winnerLayer(5,[3,10]) = crown;
            winnerLayer(4,[3,10]) = crown;
            drawScene(gameLayout, winnerLayer);
            pause(1);
    
        elseif(numRounds == 3) && (oppWin == 2)
            balance = balance - userBet;
            multipleRounds = false;
    
            %lose screen
            loserLayer = ones(12,12) * noCard;
            loserLayer(3:10,4:5) = retroCardFullArray(9,2);
            loserLayer(9:10,4:8) = retroCardFullArray(9,2);
            drawScene(gameLayout, loserLayer);
            pause(1);
    
        elseif(numRounds == 5) && (oppWin == 3)
            balance = balance - userBet;
            multipleRounds = false;
    
            %lose screen
            loserLayer = ones(12,12) * noCard;
            loserLayer(3:10,4:5) = retroCardFullArray(9,2);
            loserLayer(9:10,4:8) = retroCardFullArray(9,2);
            drawScene(gameLayout, loserLayer);
            pause(1);
    
        elseif(numRounds == 5) && (userWin == 3)
            balance = balance + userBet;
            multipleRounds = false;
           
            %win screen
            winnerLayer = ones(12,12) * noCard;
            winnerLayer(6:8,3:10) = crown;
            winnerLayer(6,[5,8]) = noCard;
            winnerLayer(5,[3,10]) = crown;
            winnerLayer(4,[3,10]) = crown;
            drawScene(gameLayout, winnerLayer);
            pause(1);

        elseif(numRounds == 1) && (userLoses)
            balance = balance - userBet;
            multipleRounds = false;
            
            %lose screen
            loserLayer = ones(12,12) * noCard;
            loserLayer(3:10,4:5) = retroCardFullArray(9,2);
            loserLayer(9:10,4:8) = retroCardFullArray(9,2);
            drawScene(gameLayout, loserLayer);
            pause(1);
         
        elseif(numRounds == 1) && (userLoses == false)
            balance = balance + userBet;
            multipleRounds = false;
            
            %win screen
            winnerLayer = ones(12,12) * noCard;
            winnerLayer(6:8,3:10) = crown;
            winnerLayer(6,[5,8]) = noCard;
            winnerLayer(5,[3,10]) = crown;
            winnerLayer(4,[3,10]) = crown;
            drawScene(gameLayout, winnerLayer);
            pause(1);
    
        else
            notEmpty = true;
            playedRounds = playedRounds + 1;
            
            press = getKeyboardInput(gameLayout);
    
            %Display the round number
            emptyBackground = ones(11,11) * noCard;
            emptyBackground(6,6) = blankCard;
            
            roundLayer = ones(11,11) * noCard;
            roundLayer(6,6) = retroCardFullArray(2,playedRounds+2);
            drawScene(gameLayout, emptyBackground, roundLayer);
            
            %Have user continue by clicking keyboard and reassign new shuffled
            %decks to both the user and the opponent
            press = getKeyboardInput(gameLayout);
            [userDeck, opponentDeck] = assignCards(retroCardFullArray);
        end
            
    end
    %missing a function to return to the game screen
    close;
    war(balance,casinoEnter, entercasinoSplash, entercasinoForeground)
end