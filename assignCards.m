function [userDeck, opponentDeck] = assignCards()
%Take a sprite array given in the driver and turn it into two shuffled,
%equally split, decks.  The function is supposed to return each deck to the 
% driver to be used in the program later.

%Suits do not matter in this game changing for readability.
%Assigning suit "decks"
%heartSuit = [spriteArray(3,:), spriteArray(4,1:3)];
%diamondSuit = [spriteArray(4, 4:end), spriteArray(5,1:6)];
%clubSuit = [spriteArray(5,7:end), spriteArray(6, 1:9)];
%spadeSuit = [spriteArray(6,end), spriteArray(7, 1:end), spriteArray(8,1:2)];

%Non-shuffled then shuffled deck
cardDeck = 21:74;
shuffledCardDeck = randperm(52);

%User Deck and Opponent Deck being created from a split shuffled deck
userDeck = shuffledCardDeck(1:26);
opponentDeck = shuffledCardDeck(27:52);

    %for loops find the appropriate card deck value by taking the value of 
    %the shuffled card deck at index i, and taking the value from the shuffled
    %card deck and using it as the index to find the value of card deck and
    %assigning it to the userDeck value at index i.
    for i=1:length(userDeck)
        userDeck(i) = cardDeck(shuffledCardDeck(i));
    end
    
    %this for loop follows the same logic as the one above.
    for i=1:length(opponentDeck)
        opponentDeck(i) = cardDeck(shuffledCardDeck(i+26));
    end

end