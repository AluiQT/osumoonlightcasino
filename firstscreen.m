function firstscreen(balance)
    %Create the splashscreen for the first screen
    splashscreen = simpleGameEngine('whack.png',199,199);
    %Create the splashscreen for the enter casino (Could do in the function
    %but I opted to pass it as an argument)
    casinoEnter = simpleGameEngine('tryingnewsheet.png',50,50,2);

%Create GUI
%Create a bunch of zeros just to set the correct size
backgroundSplash = zeros(5,5);
counterBg = 1;

%Loop through pixel indices
for i = 1:5
    for j = 1:5
        backgroundSplash(i,j) = counterBg;
        counterBg = counterBg + 1;
    end  
end

%Foreground to generate the two buttons
splashforeground = 26 * ones(size(backgroundSplash));
%Enter button
splashforeground(3,3) = 31;
%Quit button
splashforeground(4,3) = 32;

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

    %Load audio
    %This is an audiofile containing the BYE!!! from roblox sound effect
    %(https://www.youtube.com/watch?v=YyWb7MHpbJA)
    [yBye,FsBye] = audioread('BYE.mp3');
    quitSound = audioplayer(yBye,FsBye); %Turn into an object
    %These are audiofiles contatining AI generated voices saying "Welcome
    %to the moonlight casino!"
    [yWelcome1,FsWelcome1] = audioread('welcomecasino1.mp3');
    [yWelcome2,FsWelcome2] = audioread('welcomecasino2.mp3');
    [yWelcome3,FsWelcome3] = audioread('welcomecasino3.mp3');
    welcomeSound1 = audioplayer(yWelcome1,FsWelcome1);
    welcomeSound2 = audioplayer(yWelcome2,FsWelcome2);
    welcomeSound3 = audioplayer(yWelcome3,FsWelcome3);
    %Non-copyright lofi music (https://www.youtube.com/watch?v=bqNStkw3ovE)
    [yLofi,FsLofi] = audioread('lofimusiclong.mp3');
    
    lofi = audioplayer(yLofi,FsLofi);
    while 1
        if ~isplaying(lofi)
            play(lofi)
        end
        %This is to ensure that if you quit any figure it will redraw
        %the first scene until you press quit and cancel the game.
        drawScene(splashscreen,backgroundSplash,splashforeground)
        %Play the lovely music (just syntax to infinitely loop the player
        %as long as the figure is open -- currently not working?)
        try
            %Inputs to track mouse input for button clicks
            [x1, y1] = getMouseInput(splashscreen);
            %Position of the enter button
            if x1 == 3 && y1 == 3
                randomWelcome = randi([1, 3]);
                if randomWelcome == 1
                    play(welcomeSound1); %Welcome!
                elseif randomWelcome == 2
                    play(welcomeSound2); %Two more welcome sounds for variety.
                else
                    play(welcomeSound3);
                end
                pause(2); %Pause to play the audio
                close; %Close the current figure
                %Call the function to draw the next scene
                updateCasinoScreen(casinoEnter, entercasinoSplash, entercasinoForeground,balance)
            %If you're a good person who chooses not to gamble be my guest
            %(It's a losing game :) )
            elseif x1 == 4 && y1 == 3
                play(quitSound); %Bye!
                pause(2); %Pause to play the audio
                close all; %Close any figures (incase other figures are open)
                stop(lofi) %End the player
                break; %End the loop
            end
        catch
            %I'm not sure if this works in supressing errors toward the
            %console. I just read about it in documentation and it doesn't
            %seem to hurt my code.
        end
    end
end