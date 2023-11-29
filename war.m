function war(balance,casinoEnter, entercasinoSplash, entercasinoForeground)
flag = true;
while(flag)
%creates loop that begins war game and continues until player quits
   [x,y,userDecision1] = warSplashScreen();

%The conditional determines if the player wants to continue or not by
%getting mouse input and storing it in the variabe userDecision1
    %The user wants to play
    if (userDecision1 == 4 || userDecision1 == 5)
        [opScreen, UD2] = optionScreen();
        numRounds = 1;
        userBet = 0;
        flag2 = true;

        while(flag2)
            %The user chooses from 4 options on a "menu" screen (play, bet,
            %best of (how many rounds), and return).
            if (UD2 == 2)
                balance = playingWarFunction(balance, userBet, numRounds);
                flag2 = false;
    
            elseif (UD2 == 4)
                [bettingScreen, userBet] = betPage(balance);
                [opScreen, UD2] = optionScreen();
    
            elseif (UD2 == 6)
                [bestOfDisplay, numRounds] = bestOfScreen();
                [opScreen, UD2] = optionScreen();
    
            elseif (UD2 == 8)
                flag2 = false;
                
            end
        end
    
   %The user wants to go back to the main casino
   elseif (userDecision1 == 6 || userDecision1 == 7)
       %Close the figure to switch screens
        close;
        %Call the update to switch screens
        updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
        %Break to end the loop
        flag=false;
   end

end
