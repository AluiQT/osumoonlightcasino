function updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
    %Load audio
    %The audio below are ai generated voice readings of each game just to
    %add a little bit of flavor.
    [yRouletteSound, FsRouletteSound] = audioread('itsRoulette.mp3');
    [ySlotsSound, FsSlotsSound] = audioread('itsSlots.mp3');
    [yBlackjackSound, FsBlackjackSound] = audioread('itsBlackjack.mp3'); 
    [yWarSound,FsWarSound] = audioread('itsWar.mp3');
    %These create audioplayer objects for use in my loop
    itsRoulette = audioplayer(yRouletteSound, FsRouletteSound);
    itsSlots = audioplayer(ySlotsSound, FsSlotsSound);
    itsBlackjack = audioplayer(yBlackjackSound, FsBlackjackSound);
    itsWar = audioplayer(yWarSound,FsWarSound);
    while 1
        if balance == 0
            for i = 1:5
            entercasinoForeground(1,i + 4) = 195 + i;
            entercasinoForeground(2,i + 4) = 208 + i;
            entercasinoForeground(3,i + 4) = 221 + i;
            entercasinoForeground(4,i + 4) = 234 + i;
            end
        end
        entercasinoForeground = balanceButton(entercasinoForeground,balance);
        drawScene(casinoEnter, entercasinoSplash, entercasinoForeground);
        [x2, y2] = getMouseInput(casinoEnter);
        if (x2 == 5 || x2 == 6) && (y2 == 1 || y2 == 2 || y2 == 3)
            close;
            play(itsRoulette)
            pause(1)
            roulette(casinoEnter, entercasinoSplash, entercasinoForeground,balance);
            break;
        elseif (x2 == 5 || x2 == 6) && (y2 == 5|| y2 == 6)
            close;
            play(itsSlots)
            pause(1)
            slots(balance, casinoEnter, entercasinoSplash, entercasinoForeground);
            break;
        elseif (x2 == 5 || x2 == 6) && (y2 == 8 || y2 == 9)
            close;
            play(itsBlackjack)
            pause(1)
            blackjack(balance,casinoEnter, entercasinoSplash, entercasinoForeground);
            break;
        elseif (x2 == 5 || x2 == 6) && (y2 == 11 || y2 == 12)
            close;
            play(itsWar)
            pause(1)
            war(balance,casinoEnter, entercasinoSplash, entercasinoForeground);
            break;
        elseif (x2 == 1 || x2 == 2) && (y2 == 1 || y2 == 2)
            close;
            firstscreen(splashscreen,backgroundSplash,splashforeground,welcomeSound,quitSound,lofi,casinoEnter, entercasinoSplash, entercasinoForeground,balance)
            break;
        end
    end
end

%This creates the balance button
function entercasinoForeground = balanceButton(entercasinoForeground,balance)
    % Convert balance to a string with leading zeros and fixed width (5
    % digits) will break if the player makes too much money (unlikely,
    % welcome to the casino baby)
    formattedBalance = sprintf('%05d', balance); %See line 579
    for i = 1:5
        %Use math to relate the foreground position to the balance number
        entercasinoForeground(13,i+6) = 170 + str2double(formattedBalance(i));
    end
end