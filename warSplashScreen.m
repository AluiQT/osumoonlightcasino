function [screenArray, splashScreen, mouseInput] = warSplashScreen()

splashscreen_sprite_sheet_contents = [1:10; 11:20; 21:30; 31:40; 41:50; 51:60; 61:70; 71:80; 81:90; 91:100];

%Creating the game "title" and different buttons
    %Location of the war title in warPixel2
    warTitle = splashscreen_sprite_sheet_contents(8:10,2:end);

    %Location of the play button in warPixel2
    playWord = splashscreen_sprite_sheet_contents(3:4,1:5);
    
    %Location of the return button in warPixel2
    returnWord = splashscreen_sprite_sheet_contents(3:4, 6:end);

    %Location of blank pixels
    blankSpace = splashscreen_sprite_sheet_contents(5,6:end);
    blankSpaceChunk = [blankSpace;blankSpace];
    blankSpaceRow = [blankSpace, blankSpace];

    %completed array that works with the configuration of "screenArray"
    playRow = [playWord,blankSpaceChunk];
    returnRow = [returnWord, blankSpaceChunk];
    warRow = splashscreen_sprite_sheet_contents(8:10,:);

%Creating construction of rows to make display
screenArray = [warRow; playRow; returnRow; blankSpaceRow];

%Creating image displayed
splashScreen = simpleGameEngine('warPixel2.png',9,9,15,[103,58,183]); %8x5 is the h and w for one letter
drawScene(splashScreen, screenArray)
mouseInput = getMouseInput(splashScreen);
close;
end